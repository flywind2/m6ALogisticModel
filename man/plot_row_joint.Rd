% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_row_joint.R
\name{plot_row_joint}
\alias{plot_row_joint}
\title{Plot the joint distribution between rows of a genomic assay.}
\usage{
plot_row_joint(SE, HDER = "Row_joint", K = 3, ROW_STAND = T,
  RETURN_INDX = F, PROVIDE_INDX = NULL)
}
\arguments{
\item{SE}{A \code{SummarizedExperiment} with features annotated by \code{\link{predictors.annot}}, the colnames of the SummarizedExperiment should be sample names.}

\item{HDER}{The subtitle and the file name of the plot.}

\item{K}{Number of centers used in K medoids clustering.}

\item{ROW_STAND}{Whether to standardize rows before clustering, default is TRUE.}

\item{RETURN_INDX}{Whether to return the clustering index, default is TRUE.}
}
\value{
A clustering index, also a plot will be saved under a file named by \code{HDER}.
}
\description{
\code{plot_column_joint} is a function used to evaluate the clustering quality between m6A sites.
}
\details{
By default, a K medoids clustering will be applied between rescaled row entires with metric of euclidean; then, a simplified heat map will be plotted.
Finally, a report by multinomial GLM is conducted using the clustering label and features.

The suggested quick check row number for SE should be less than 10000, otherwise this function would be time consuming.

About silhouette plot (from wikipedia).

The average silhouette of the data is another useful criterion for assessing the natural number of clusters.
The silhouette of a data instance is a measure of how closely it is matched to data within its cluster and how loosely it is matched to data of the neighbouring cluster,
i.e. the cluster whose average distance from the datum is lowest.
A silhouette close to 1 implies the datum is in an appropriate cluster, while a silhouette close to −1 implies the datum is in the wrong cluster.
Optimization techniques such as genetic algorithms are useful in determining the number of clusters that gives rise to the largest silhouette.
It is also possible to re-scale the data in such a way that the silhouette is more likely to be maximised at the correct number of clusters
}
\examples{

eval_row_joint(SE_features_added, "Row_joint_CQN")

}
\seealso{
\code{\link{predictors.annot}},  \code{\link{glm_multinomial}}, \code{\link{go_multinomial}}
}
