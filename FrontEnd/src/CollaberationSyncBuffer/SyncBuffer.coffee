#########################################################################
#																		#
# When using the networked collaberation it may be they 				#
# case that updates to model objects are being applied					#
# before they are part of the model. This class bufferes and applys they#
# updated to models untill they are added to the document model.		#
#																		#
#########################################################################
class window.UML.CollaberationSyncBuffer.SyncBuffer
	constructor:()->
		@modelBufferedItems = new IDIndexedList((item)-> item.modelItemID)

	addItem:(item)->
		if(item.hasOwnProperty("modelID"))
			@addItemUpdate(item)
		else if(item.hasOwnProperty("modelListID"))
			@addListUpdate(item)
		else
			Debug.write("invalid Model object supplied for network update: "+item)


	addItemUpdate:(item)->
			modelItem = window.UML.MODEL.ModelItems.get(item.modelID) 
			if(modelItem != null)
				@assignNewValue(item, modelItem);
			else
				@createNewItem(item);

	createNewItem:(item)->
		modelItem = new window.UML.MODEL.ModelItem(item.modelID)
		@assignNewValue(item, modelItem);

	assignNewValue:(update, modelItem)->
		if(update.new_value.hasOwnProperty("modelListID")) #check if we are adding a new list to the object
			modelList = new window.UML.MODEL.ModelList(update.new_value.modelListID)
			modelItem.setFromNetwork(update.name, modelList)
		else if(update.new_value.hasOwnProperty("modelItemID")) #check if we are adding a new item to the object
			newmodelItem = window.UML.MODEL.ModelItems.get(update.new_value.modelItemID)
			if newmodelItem == null
				newmodelItem = new window.UML.MODEL.ModelItem(update.new_value.modelItemID)
			modelItem.setFromNetwork(update.name, newmodelItem)
		else
			if window.UML.typeIsObject(update.new_value)

				if modelItem.get(update.name)
					# if the update is a full object the copy the feilds over individually
					# this is to prevent an update object stamping over a type
					for key, value of update.new_value
							modelItem.get(update.name)[key] = value;

					# assign value to itself to force an update
					modelItem.setFromNetwork(update.name,modelItem.get(update.name), true)
				else
					modelItem.setFromNetwork(update.name, @inferType(update.new_value));
			else
				modelItem.setFromNetwork(update.name,update.new_value)

	inferType:(value)->
		if value.hasOwnProperty("x") && value.hasOwnProperty("y")
			return new Point(value.x, value.y);

	addListUpdate:(list)->
			listItem = window.UML.MODEL.ModelLists.get(list.modelListID)
			if(listItem != null)
				if(list.changeType =="ADD")
					if(list.item.hasOwnProperty("modelItemID"))
						listModelItem = list.item
						modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID)
						if modelItem == null
							@createNewItem(listModelItem)
							modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID)

						listItem.pushFromNetwork(modelItem)
							
					else if(list.item.hasOwnProperty("modelListID"))
						Debug.write("Adding list to list Unimplemented ERROR: ")
					else
						Debug.write("invalid model item requested to append to list: "+list.item)
				else if(list.changeType == "DEL")

					if(list.item.hasOwnProperty("modelItemID"))
							listModelItem = list.item
							modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID)
							if modelItem == null
								Debug.write("invalid model item requested to append to list: "+list.item)

							listItem.removeFromNetwork(modelItem)
								
					else if(list.item.hasOwnProperty("modelListID"))
							listModellist = list.item
							listModellist = window.UML.MODEL.ModelLists.get(list.modelListID)
							if listModellist == null
								Debug.write("invalid model list requested to append to list: "+list.item)

							listItem.removeFromNetwork(listModellist)

					