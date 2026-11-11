"use strict";
/* No external dependencies, trackers, storage of sensitive content, or network calls. */
document.documentElement.classList.add("js");
const themeBtn = document.getElementById("theme-toggle");
const filterButtons = [...document.querySelectorAll("[data-filter]")];
const cards = [...document.querySelectorAll("[data-category]")];
const reveal = [...document.querySelectorAll("[data-reveal]")];
const year = document.getElementById("year");
if (year) year.textContent = String(new Date().getFullYear());

function setTheme(theme) {
  const selected = theme === "light" ? "light" : "dark";
  document.documentElement.setAttribute("data-theme", selected);
  if (themeBtn) {
    themeBtn.setAttribute("aria-label", selected === "light" ? "Switch to dark appearance" : "Switch to light appearance");
    themeBtn.setAttribute("aria-pressed", String(selected === "light"));
  }
}
const media = window.matchMedia && window.matchMedia("(prefers-color-scheme: light)");
setTheme(media && media.matches ? "light" : "dark");
if (media && media.addEventListener) {
  media.addEventListener("change", (event) => {
    if (!document.documentElement.dataset.userTheme) setTheme(event.matches ? "light" : "dark");
  });
}
if (themeBtn) {
  themeBtn.addEventListener("click", () => {
    const next = document.documentElement.dataset.theme === "light" ? "dark" : "light";
    document.documentElement.dataset.userTheme = "1";
    setTheme(next);
  });
}
function activateFilter(filter) {
  filterButtons.forEach((button) => {
    const active = button.dataset.filter === filter;
    button.classList.toggle("active", active);
    button.setAttribute("aria-pressed", String(active));
  });
  cards.forEach((card) => {
    const groups = (card.dataset.category || "").split(/\s+/);
    card.hidden = !(filter === "all" || groups.includes(filter));
  });
}
filterButtons.forEach((button) => {
  button.addEventListener("click", () => activateFilter(button.dataset.filter || "all"));
});
if ("IntersectionObserver" in window && !window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add("is-visible");
      observer.unobserve(entry.target);
    });
  }, { threshold: 0.10, rootMargin: "0px 0px -12px 0px" });
  reveal.forEach((element) => observer.observe(element));
} else {
  reveal.forEach((element) => element.classList.add("is-visible"));
}
