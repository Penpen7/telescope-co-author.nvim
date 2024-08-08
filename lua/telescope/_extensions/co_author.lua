return require("telescope").register_extension {
  exports = {
    co_author = require("telescope_co_author").co_author,
  }
}
