export default {
  install: Vue => {
    Vue.directive("focus", {
      inserted(el, binding) {
        if (binding.value === true || binding.value === undefined) el.focus();
      }
    });

    Vue.directive("only-numbers", {
      bind: el => el.addEventListener("keydown", onlyNumbersHandler),
      unbind: el => el.removeEventListener("keydown", onlyNumbersHandler)
    });
  }
};

const onlyNumbersHandler = event => {
  if (event.key === "Backspace" || event.key === "F5" || event.key === "Tab")
    return;
  const reg = new RegExp(/^\d+$/);
  if (!reg.test(event.key)) event.preventDefault();
};
