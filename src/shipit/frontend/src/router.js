export default (history, routes) => ({
  history,
  emit: route => () => {
    history.push(routes.getURLForRoute(route));
  },
  subscribe() {
    let unlisten;
    return {
      effect(dispatch) {
        unlisten = history.listen((location) => {
          dispatch(routes.getRouteForURL(location.pathname));
        });
        history.push();
      },
      cancel() {
        if (unlisten !== undefined) {
          unlisten();
        }
      },
    };
  },
});
