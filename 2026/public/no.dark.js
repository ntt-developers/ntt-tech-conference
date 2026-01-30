// 強制的に Light を設定
document.addEventListener("DOMContentLoaded", () => {
  document.body.setAttribute("data-theme", "light");

  // app.min.js の関数が存在する場合だけ上書き実行
  if (typeof toggleThemeIcon === "function") {
    toggleThemeIcon("light");
  }
  if (typeof toggleThemeInfo === "function") {
    toggleThemeInfo("light");
  }
});

// toggleTheme を無効化（ユーザーが押しても切り替わらない）
if (typeof toggleTheme === "function") {
  toggleTheme = function () {
    document.body.setAttribute("data-theme", "light");
    localStorage.setItem("theme", "light");

    toggleThemeIcon("light");
    toggleThemeInfo("light");
  };
}
