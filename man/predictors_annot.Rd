% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predictors_annot.R
\name{predictors_annot}
\alias{predictors_annot}
\title{Generate predictors/features for a range based RNA modification data.}
\usage{
predictors_annot(se, txdb, bsgnm, fc = NULL, pc = NULL,
  struct_hybridize = NULL, feature_lst = NULL, motif = c("AAACA",
  "GAACA", "AGACA", "GGACA", "AAACT", "GAACT", "AGACT", "GGACT", "AAACC",
  "GAACC", "AGACC", "GGACC"), motif_clustering = "DRACH",
  annot_clustering = NULL, hk_genes_list = NULL,
  isoform_ambiguity_method = c("longest_tx", "average"),
  genes_ambiguity_method = c("drop_overlap", "average"),
  standardization = TRUE)
}
\arguments{
\item{se}{A \code{\link{SummarizedExperiment}} object containing the \code{rowRanges} for modifications. \code{colData} and \code{assay} are not neccessarily specified for this function.}

\item{txdb}{\code{TxDb} object for annotating the corresponding \code{rowRanges}, this is either obtained from bioconductor or converted from the annotation files by \code{GenomicFeatures::makeTxDbFromGFF}.}

\item{bsgnm}{\code{\link{BSgenome}} object for genomic sequence annotation, this should be downloaded from bioconductor.}

\item{fc, pc}{Optional; \code{GScores} objects for annotations of standardized Fitness consequences scores and UCSC phastCons conservation scores.

Gulko B, Melissa J. Hubisz, Gronau I and Siepel A (2015). “Probabilities of fitness consequences for point mutations across the human genome.” Nature Genetics, 47, pp. 276-283.

Siepel A and al. e (2005). “Evolutionarily conserved elements in vertebrate, insect, worm, and yeast genomes.” Genome Research, 15, pp. 1034-1050.}

\item{struct_hybridize}{Optional; A \code{\link{GRanges}} or \code{\link{GRangesList}} object indicating the hybridized region on the transcribed or exonic regions.

The precomputed MEA 2ndary structures could be find at the data attached in this package: \code{\link{Struc_hg19}} and \code{\link{Struc_mm10}}.}

\item{feature_lst}{Optional; A list of \code{\link{GRanges}} for user defined features, the names of the list will correspond to the names of features.}

\item{motif}{A character vector indicating the motifs centered by the modification nucleotite, the motif will not be attached if the \code{rowRanges} of \code{se} is not single nucleotide resolution (with all width = 1).

By default, the motif selected is RRACH: c("AAACA","GAACA","AGACA","GGACA","AAACT","GAACT","AGACT","GGACT","AAACC","GAACC","AGACC","GGACC").}

\item{motif_clustering}{A character vector indicating the motif used to generate the features for the clustering indexes, Default: "DRACH".}

\item{annot_clustering}{A \code{\link{GRanges}} object to generate clustering features. Default: NULL.

The resulting clustering features will be named \code{clust_f100}, \code{clust_f1000}, \code{dist_nearest_p200}, and \code{dist_nearest_p2000}}

\item{hk_genes_list}{Optional; A character string of the Gene IDs of the House Keeping genes. The Gene IDs should correspond to the Gene IDs used by the provided \code{TxDb} object.

The entrez gene IDs of the house keeping genes of mm10 and hg19 are included in this package: \code{HK_hg19_eids} and \code{HK_mm10_eids}.}

\item{isoform_ambiguity_method}{Can be "longest_tx" or "average". The former keeps only the longest transcript as the transcript annotation.
The later will use the average feature entries for multiple mapping of the transcript isoform.}

\item{genes_ambiguity_method}{Can be "drop_overlap" or "average". The former will not annotate the modification sites overlapped with > 1 genes (By returning NA).
The later will use the average feature entries for mapping of multiple genes.}

\item{standardization}{A logical indicating whether to standardize the continous features; Default TRUE.}
}
\value{
This function will return a \code{\link{SummarizedExperiment}} object with a \code{mcols} of a feature or design matrix.
}
\description{
\code{predictors_annot} is used to generate features given a \code{SummarizedExperiment} object of RNA modification / target.
}
\details{
This function retreave transcript related features that are previous known to be related with m6A modifications based on
provided \code{rowRanges} of the \code{SummarizedExperiment},
and it return features in forms of meta data collums of the \code{SummarizedExperiment}.

The features that must be included:


  ###1. Transcript regions ### ---- The entries are logical / dummy variables.

- UTR5: 5'UTR.

- UTR3: 3'UTR.

- cds: Coding Sequence.

- Stop_codons: Stop codon (301 bp center).

- Start_codons: Start codon (201 bp center).

- m6Am: 5'Cap m6Am (TSS that has underlying sequence of A).

- Exons: Exonic regions.

- last_exons_50bp: Start 50bp of the last exon of a transcript.



  ###2. Relative positions ### ---- The entries fall into the scale of [0,1].  If the site is not mapped to any range on the right, the value is set to 0. (can be viewed as an interactive term on top of the region model.)

- pos_UTR5: Relative positioning on 5'UTR.

- pos_UTR3: Relative positioning on 3'UTR.

- pos_cds: Relative positioning on Coding Sequence.

- pos_Tx: Relative positioning on Transcript.

- pos_exons: Relative positioning on exons.


   ###3. Region length ###

- long_UTR3: Long 3'UTR (length > 400bp).

- long_exon: Long exon (length > 400bp).

- Gene_length_ex: standardized gene length of exonic regions (z score).

- Gene_length_all: standardized gene length of all regions (z score).



  #####=============== The following features that are optional ===============#####

   ###4. Motif ###

by default it includes the following motifs search c("AAACA","GAACA","AGACA","GGACA","AAACT","GAACT","AGACT","GGACT","AAACC","GAACC","AGACC","GGACC"): i.e. instances of RRACH.

   ###5. Evolutionary fitness ###

- PC 1bp: standardized PC score 1 nt.

- PC 201bp: standardized PC score 101 nt.

- FC 1bp: standardized Fitness consequences scores 1bp.

- FC 5nt: standardized Fitness consequences scores 101bp.

   ###6. User specified features by argument \code{feature_lst} ###

The entries are logical / dummy variables, specifying whether overlapping with each GRanges or GRanges list.

   ###7.Gene attribute ###

- sncRNA: small noncoding RNA (<= 200bp)

- lncRNA: long noncoding RNA (> 200bp)

- Isoform_num: Transcript isoform numbers standardized by z score.

- HK_genes: mapped to house keeping genes, such as defined by paper below.

Eisenberg E, Levanon EY (October 2013). "Human housekeeping genes, revisited". Trends in Genetics. 29

  ###7.Batch effect ###

- GC_cont_genes: GC content of each gene.

- GC_cont_101bp: GC content of 101bp local region of the sites.
}
\examples{
### ==== For hg19 ==== ###

library(SummarizedExperiment)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(BSgenome.Hsapiens.UCSC.hg19)
library(fitCons.UCSC.hg19)
library(phastCons100way.UCSC.hg19)


Feature_List_hg19 = list(
HNRNPC_eCLIP = eCLIP_HNRNPC_gr,
YTHDC1_TREW = YTHDC1_TREW_gr,
YTHDF1_TREW = YTHDF1_TREW_gr,
YTHDF2_TREW = YTHDF2_TREW_gr,
miR_targeted_genes = miR_targeted_genes_grl,
#miRanda = miRanda_hg19_gr,
TargetScan = TargetScan_hg19_gr,
Verified_miRtargets = verified_targets_gr
)

SE_features_added <- predictors_annot(se = SummarizedExperiment(rowRanges = hg19_miCLIP_gr),
txdb = txdb,
bsgnm = Hsapiens,
fc = fitCons.UCSC.hg19,
pc = phastCons100way.UCSC.hg19,
struct_hybridize = Struc_hg19,
feature_lst = Additional_features_hg19,
hk_genes_list = HK_hg19_eids,
motif = c("AAACA","AGACA","AAACT","AGACT","AAACC","AGACC",
          "GAACA","GGACA","GAACT","GGACT","GAACC","GGACC",
          "TAACA","TGACA","TAACT","TGACT","TAACC","TGACC"),
motif_clustering = "DRACH",
standardization = F,
genes_ambiguity_method = "average")


mcols(SE_features_added) ###Check the generated feature matrix.


}
\seealso{
\code{\link{glm_bas}}, \code{\link{glm_multinomial}}, \code{\link{glm_regular}} to perform model selection, statistics calculation, and visualization across multiple samples.
}
