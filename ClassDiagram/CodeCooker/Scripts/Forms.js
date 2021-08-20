Forms = {};

Forms.selectContentSwap =  function(selectElement, contentElement, SwapList)
{
    selectElement.bind({
        change: function () {
            Forms.selectionChanged(selectElement, contentElement, SwapList);
        }
    });


}

Forms.selectionChanged = function(selectElement, contentElement, swapList)
{
    newContent = swapList[selectElement[0].selectedIndex];
    contentElement.fadeTo("fast",
                          0,
                          function () {
                              contentElement.html(newContent);
                              contentElement.fadeTo("fase", 1);
                          });
}

