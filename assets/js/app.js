// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let EditorSettings = {
    directions: {
        toolbar: [ 'heading', '|',
                   'bold', 'italic', '|',
                   'numberedList', '|',
                   'blockQuote', 'link', '|',
                   'undo', 'redo'],
        shouldNotGroupWhenFull: true,
        heading: {
            options: [
                { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                { model: 'heading1', view: 'h1', title: 'Heading', class: 'ck-heading_title' }
            ]
        }
    },
    description: {
        toolbar: [ 'bold', 'italic', '|',
                   'undo', 'redo'],
        shouldNotGroupWhenFull: true
    }
};

window.recipe_editor = {};
window.recipe_editor_data = {};

function CKEditorHook(settings, name) {
    let createEditor = (el, name) => {
        ClassicEditor
            .create( el , settings )
            .catch( error => {
                console.log( error );
            }).then(e => {
                window.recipe_editor[name] = e;
                let data = window.recipe_editor_data[name];
                data && window.recipe_editor[name].setData(data);
            });
    }

    return {
        mounted() { createEditor(this.el, name) },
        beforeUpdate() {
            window.recipe_editor_data[name] = window.recipe_editor[name].getData()
        },
        updated() {
            let editor = window.recipe_editor[name];
            if (editor) { editor.destroy() }
            createEditor(this.el, name)
        },
        destroyed() {
            window.recipe_editor_data = {}
            window.recipe_editor = {}

        }
    }
}

let SearchBar = {
  mounted() {
      let searchParams = new URLSearchParams(window.location.search);
      let query = searchParams.get('q');
      if (query) {
          let input = document.querySelector('#search-input');
          input.value = query
      }
      const searchBarContainer = this.el
      document.addEventListener('keydown', (event) => {
          if (event.key !== 'ArrowUp' && event.key !== 'ArrowDown') {
              return
          }

          const focusElement = document.querySelector(':focus')

          if (!focusElement) {
              return
          }

          if (!searchBarContainer.contains(focusElement)) {
              return
          }

          event.preventDefault()

          const tabElements = document.querySelectorAll(
              '#search-input, #searchbox__results_list a',
          )
          const focusIndex = Array.from(tabElements).indexOf(focusElement)
          const tabElementsCount = tabElements.length - 1

          if (event.key === 'ArrowUp') {
              tabElements[focusIndex > 0 ? focusIndex - 1 : tabElementsCount].focus()
          }

          if (event.key === 'ArrowDown') {
              tabElements[focusIndex < tabElementsCount ? focusIndex + 1 : 0].focus()
          }
      })
  },
}

let Hooks = {}
Hooks.RecipeDirections = CKEditorHook(EditorSettings.directions, 'directions')
Hooks.RecipeDescription = CKEditorHook(EditorSettings.description, 'description')
Hooks.SearchBar = SearchBar

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.delayedShow(200))
window.addEventListener("phx:page-loading-stop", info => topbar.hide())


// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
