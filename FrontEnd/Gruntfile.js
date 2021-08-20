module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

      qunit: {
        all: ['test/**/*.html']
      },

      concat: {
          options: {
            separator: '\n\n',
            },
          all: {
            src: ['src/Namespace.coffee',
                  'src/Interactive/*.coffee',
                  'src/**/Namespace.coffee',
                  'src/IDIndexedList.coffee',
                  'src/Point.coffee',
                  'src/Event.coffee',
                  'src/TextBoxClasses/HighlightableBox.coffee',
                  'src/TextBoxClasses/EdiableTextBox.coffee',
                  'src/TextBoxClasses/IntelligentPoputPositioning/IntellegentPopoutPositioning.coffee',
                  'src/TextBoxClasses/*.coffee',
                  'src/Arrows/ArrowEndPoint.coffee',
                  'src/Arrows/*.coffee',
                  'src/UMLElements/MoveableObject.coffee',
                  'src/UMLElements/InheritableObject.coffee',
                  'src/UMLElements/*',
                  'src/ContextMenu/ContextMenu.coffee',
                  'src/ContextMenu/*.coffee',
                  'src/SelectedGroup.coffee',
                  'src/Selectons.coffee',
                  'src/StringTree/*.coffee',
                  'src/Model/ModelItem.coffee',
                  'src/Model/*.coffee',
                  'src/CollaberationSyncBuffer/*',
				          'src/Namespaces.coffee',
                  'src/{,*/}*.coffee'],
            dest: 'js/full.coffee',
          },
        noMain: {
          src: [  'src/Namespace.coffee',
                  'src/Interactive/*.coffee',
                  'src/**/Namespace.coffee',
                  'src/IDIndexedList.coffee',
                  'src/Point.coffee',
                  'src/Event.coffee',
                  'src/TextBoxClasses/HighlightableBox.coffee',
                  'src/TextBoxClasses/EdiableTextBox.coffee',
                  'src/TextBoxClasses/IntelligentPoputPositioning/IntellegentPopoutPositioning.coffee',
                  'src/TextBoxClasses/*.coffee',
                  'src/Arrows/ArrowEndPoint.coffee',
                  'src/Arrows/*.coffee',
                  'src/UMLElements/MoveableObject.coffee',
                  'src/UMLElements/InheritableObject.coffee',
                  'src/UMLElements/*',
                  'src/ContextMenu/ContextMenu.coffee',
                  'src/ContextMenu/*.coffee',
                  'src/SelectedGroup.coffee',
                  'src/Selectons.coffee',
                  'src/StringTree/*.coffee',
                  'src/Actions/Handlers/Move_movable.coffee',
                  'src/Actions/Handlers/EditBoxChange.coffee',
                  'src/Model/ModelItem.coffee',
                  'src/Model/*.coffee',
                  'src/CollaberationSyncBuffer/*',
				          'src/Namespaces.coffee',
                  'src/{,*/}*.coffee',
                  '!src/Main.coffee'],
            dest: 'js/full.coffee',
        }
      },
      coffee: {
        compile:{
          expand: true,
          flatten: true,
          cwd: "js/",
          src: ['full.coffee'],
          dest: 'js/',
          ext: '.js'
        },
        compileBare:{
          options: {
              bare: true
          },
          expand: true,
          flatten: true,
          cwd: "js/",
          src: ['full.coffee'],
          dest: 'js/',
          ext: '.js'
        }
       },

       copy: {
          main: {
            files: [
              {src: 'js/full.js', dest: '../ClassDiagram/CodeCooker/Content/JS/UML.js'},
              {src: 'js/full.js', dest: '../ClassDiagram/CodeCooker/Scripts/UML.js'}

            ]
        }
      }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-qunit');

  // Default task(s).
  grunt.registerTask('default', ['concat:all', 'coffee:compile','copy']);
  grunt.registerTask('unitTests', ['concat:noMain','coffee:compileBare','qunit']);

};