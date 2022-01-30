import _ from "lodash";

export const findThumbnailById = (state, id) => {
  return _.chain(state)
    .map("thumbnails")
    .flatten()
    .find({ id })
    .value();
};
