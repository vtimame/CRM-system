import oc from 'open-color/open-color.json'

export const OpenColor = {
    install: (Vue) => {
        Vue.prototype.$oc = oc;
    },
};
