import { inter } from "@/components/Providers";
import { extendTheme } from "@chakra-ui/react";

const theme = extendTheme({
  colors: {
    brand: {
       50: "#FFFFFF",
      100: "#FFFFFF",
      200: "#FFFFFF",
      300: "#655793ff",
      400: "#688d9bff",
      500: "#81bcc7ff",
      600: "#609a7cff",
      700: "#4d5788ff",
      800: "#253e62ff",
      900: "#1d1263ff",
    },
    beige: {
      180: "#f7f7f7ff",
      100: "#CDCACA",
      200: "#B9B6B5",
      300: "#A5A1A0",
      400: "#918D8B",
      500: "#7D7876",
      600: "#605C5B",
      700: "#434140",
      800: "#262524",
      900: "#0A0909",
    },
  },
  styles: {
    global: {
      body: {
        bg: "#faf6f5",
      },
    },
  },
  fonts: {
    heading: `'${inter.style.fontFamily}', Fredoka, sans-serif`,
    body: `'${inter.style.fontFamily}', sans-serif`,
  },
  components: {
    Button: {
      variants: {
        brand: {
          transition: "all 0.2s",
          bg: "brand.500",
          color: "blackAlpha.700",
          shadow: "lg",
          borderWidth: "3px",
          borderColor: "blackAlpha.100",
          _hover: {
            shadow: "md",
          },
        },
      },
    },
    Link: {
      variants: {
        brand: {
          transition: "all 0.2s",
          bg: "brand.500",
          color: "blackAlpha.700",
          shadow: "lg",
          borderWidth: "3px",
          borderColor: "blackAlpha.700",
          _hover: {
            shadow: "md",
          },
        },
      },
    },
  },
});

export default theme;
