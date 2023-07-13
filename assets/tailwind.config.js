// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
      screens: {
          'xs': '405px'
      },
      fontFamily: {
        'sans': ['Helvetica', 'Arial', 'sans-serif'],
        'serif': ['Georgia', 'Times', 'Times New Roman', 'serif' ],
        'head': [ 'Gloock', 'serif'],
        'racing': ['Racing Sans One', 'Helvetica', 'sans']
      },
      colors: {
        brand: {
          DEFAULT: "#3aadec",
          light: "#e4eef3",
        },
        blood: "#ef7801",
        skin: {
          DEFAULT: "#fbb506",
          light: "#ffca22",
          lighter: "#ffcb23",
        },
        black: "#181A18",
        red: "#ef4444",
        orange: "#fb923c",
        sweet: "#f97316",
        green: "#8fff73",
        grey: "#181A18",
        bubbles:"#fef08a",
        fino: "#fbbf24",
        neutral: "#f2f2f2"
      },

      keyframes: {
        wave: {
          '0%': { transform: 'rotate(0.0deg)' },
          '10%': { transform: 'rotate(14deg)' },
          '20%': { transform: 'rotate(-8deg)' },
          '30%': { transform: 'rotate(14deg)' },
          '40%': { transform: 'rotate(-4deg)' },
          '50%': { transform: 'rotate(10.0deg)' },
          '60%': { transform: 'rotate(0.0deg)' },
          '100%': { transform: 'rotate(0.0deg)' },
        },

        bounceBack: {
          '0%, 100%': {
            transform: 'translateX(-3px)',
          },
          '50%': {
            transform: 'translateX(0)',
          },
        },
      },
      animation: {
        'bounce-left-to-right': 'bounceBack 1s infinite',
        'waving': 'wave 2s linear infinite',
        'wave': 'wave 2s linear 2',
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),
    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).map(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, {values})
    })
  ]
}
