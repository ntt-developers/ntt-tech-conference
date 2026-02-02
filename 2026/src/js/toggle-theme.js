const toggleThemeIcon = (theme) => {
  const themeIcon = document.getElementById("theme-icon");

  if (theme === "light") {
    themeIcon.classList.remove("fa-sun-bright");
    themeIcon.classList.add("fa-moon");
  } else if (theme === "dark") {
    themeIcon.classList.remove("fa-moon");
    themeIcon.classList.add("fa-sun-bright");
  }
};

const toggleThemeInfo = (theme) => {
  const elements = document.getElementsByClassName("is-toggle-info");

  Array.from(elements).map((element) => {
    if (theme === "light") {
      element.classList.remove("is-info");
    } else if (theme === "dark") {
      element.classList.add("is-info");
    }
  });
};

const toggleTheme = () => {
  const isTheme = document.body.getAttribute("data-theme");
  let theme = undefined;

  if (isTheme === "light") {
    theme = "dark";
  } else if (isTheme === "dark") {
    theme = "light";
  }

  document.body.setAttribute("data-theme", theme);
  localStorage.setItem("theme", theme);

  toggleThemeIcon(theme);
  toggleThemeInfo(theme);
};

document.addEventListener("DOMContentLoaded", () => {
  const isDark = window.matchMedia("(prefers-color-scheme: dark)");
  const isLocal = localStorage.getItem("theme");
  let theme = undefined;

  if (isLocal) {
    theme = isLocal;
  } else if (isDark.matches) {
    theme = "dark";
  } else {
    theme = "light";
  }

  document.body.setAttribute("data-theme", theme);

  toggleThemeIcon(theme);
  toggleThemeInfo(theme);
});
