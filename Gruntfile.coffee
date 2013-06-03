module.exports = (grunt) ->
    grunt.initConfig
        coffeelint:
            options: grunt.file.readJSON "coffeelint.json"
            server: ["server/!{common}/**/*.coffee"]
            client: ["client/!{common}/**/*.coffee"]

        coffee:
            client:
                options:
                    sourceMap: true
                files: [{
                    expand: true
                    cwd: "build/"
                    src: ["**/*.coffee"]
                    dest: "web/js/client/"
                    ext: ".js"
                }]

        less:
            development:
                options:
                    paths: ["client/less"]
                files: [{
                    expand: true
                    cwd: "client/less/"
                    src: ["**/*.less"]
                    dest: "web/css/"
                    ext: ".css"
                }]

        transpile:
            server:
                type: "cjs"
                coffee: true
                files: [{
                    expand: true
                    cwd: 'common/'
                    src: ['**/*.coffee']
                    dest: 'server/common/'
                }]
            client:
                type: "amd"
                coffee: true
                files: [{
                    expand: true
                    cwd: 'common/'
                    src: ['**/*.coffee']
                    dest: 'client/common/'
                }]
            clienOnly:
                type: "amd"
                coffee: true
                files: [{
                    expand: true
                    cwd: 'client/'
                    src: ['**/*.coffee']
                    dest: 'build/'
                }]

        jade:
            development:
                options:
                    pretty: true
                    client: true
                files: [{
                    expand: true
                    cwd: 'client/templates/'
                    src: ["**/*.jade"]
                    dest: "web/"
                }]

        exec:
            server:
                command: "./node_modules/.bin/coffee server/init.coffee"

        bgShell:
            _defaults:
                bg: true
            livereload:
                cmd: "grunt reload"
            server:
                cmd: "grunt exec"
                bg: false

        clean:
            transpile: ["server/common", "client/common", "build"]
            build: ["build"]
            release: ["web/js", "web/css", "web/fonts", "web/img"]

        regarde:
            server:
                files: "server/**/*.coffee"
                tasks: ["coffeelint:server"]
            scripts:
                files: "client/**/*.coffee"
                tasks: ["coffeelint:client", "transpile:clienOnly", "coffee:client", "livereload"]
            common:
                files: "common/**/*.coffee"
                tasks: ["transpile:server", "transpile:client", "livereload"]
            less:
                files: "client/less/**/*.less"
                tasks: ["less", "livereload"]
            serverTemplates:
                files: "server/views/**/*.jade"
                tasks: ["livereload"]
            clientTemplates:
                files: "client/templates/**/*.jade"
                tasks: ["jade", "livereload"]
            vendor:
                files: "client/vendor/**/*.*"
                tasks: ["copy:vendor", "livereload"]
            requireRoot:
                files: "client/app.js"
                tasks: ["copy:requireConfig", "livereload"]

        copy:
            vendor:
                files: [{
                    expand: true
                    cwd: "client/vendor"
                    src: ["**"]
                    dest: "web/"
                }]
            requireConfig:
                files: [{
                    src: "client/app.js"
                    dest: "web/js/app.js"
                }]

    grunt.loadNpmTasks "grunt-coffeelint"
    #grunt.loadNpmTasks "grunt-buster"
    grunt.loadNpmTasks "grunt-regarde"
    grunt.loadNpmTasks "grunt-bg-shell"
    grunt.loadNpmTasks "grunt-exec"
    grunt.loadNpmTasks "grunt-es6-module-transpiler"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-jade"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-concat"
    grunt.loadNpmTasks "grunt-contrib-livereload"

    grunt.registerTask "build", ["coffeelint", "transpile", "coffee", "less", "jade:development", "copy"]
    grunt.registerTask "reload", ["livereload-start", "regarde"]
    grunt.registerTask "default", ["bgShell"]