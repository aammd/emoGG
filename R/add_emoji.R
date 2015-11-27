#' Input an emoji image and create a ggplot2 layer to add to an existing plot
#'
#' @import grid
#' @export
#' @param img A png object, e.g, from using \code{emoji_get}.
#' @param alpha A value between 0 and 1, specifying the opacity.
#' @param x x value of the emoji center. Ignored if y and ysize are not specified.
#' @param y y value of the emoji center. Ignored if x and ysize are not specified.
#' @param ysize Height of the emoji. The width is determined by the aspect ratio of the original image. Ignored if x and y are not specified.
#' @param color Color to plot the emoji in.
#' @details Use parameters \code{x}, \code{y}, and \code{ysize} to place the emoji at a specified position on the plot. If all three of these parameters are unspecified, then the emoji will be plotted to the full height and width of the plot.
#' @examples \dontrun{
#' # Put a emoji behind a plot
#' library(ggplot2)
#' flower <- emoji_get("1f337" )[[1]]
#' qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + add_emoji(flower)
#'
#' # Put a silhouette anywhere
#' posx <- runif(50, 0, 10)
#' posy <- runif(50, 0, 10)
#' sizey <- runif(50, 0.4, 2)
#'
#' cat <- emoji_get("1f697" )[[1]]
#' p <- ggplot(data.frame(x = posx, y = posy), aes(x, y)) +
#'             geom_point(color = rgb(0,0,0,0))
#' for (i in 1:50) {
#'   p <- p + add_emoji(cat, 1, posx[i], posy[i], sizey[i])
#' }
#' @note Based on \code{add_phylopic} from \code{rphylopic} by Scott Chamberlain.
add_emoji <- function(img, alpha = 0.2, x = NULL, y = NULL, ysize = NULL, color = NULL){

  # color and alpha the animal
  mat <- recolor_phylopic(img, alpha, color)

  if (!is.null(x) && !is.null(y) && !is.null(ysize)){
    aspratio <- nrow(mat) / ncol(mat) ## get aspect ratio of original image
    ymin <- y - ysize / 2
    ymax <- y + ysize / 2
    xmin <- x - ysize / aspratio / 2
    xmax <- x + ysize / aspratio / 2
  } else {
    ymin <- -Inf ## fill whole plot...
    ymax <- Inf
    xmin <- -Inf
    xmax <- Inf
  }
  imgGrob <- rasterGrob(mat)
  return(
    annotation_custom(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax, imgGrob)
  )
}