data/barrier.csv data/comments.csv data/horse_info.csv data/results.csv data/trackwork.csv:
	python src/download_data.py https://raw.githubusercontent.com/v5y8/horse_race_data/master data/raw_files

data/data_test.csv data/data_train.csv: data/barrier.csv data/comments.csv data/horse_info.csv data/results.csv data/trackwork.csv
	python src/wrangle_data.py data/raw_files data

img/age_dist.png img/correlation_plot.png img/country_dist.png img/heatmap_null.png img/weight_dist.png img/results_plot.png: data/data_test.csv data/data_train.csv
	python src/eda.py data img && Rscript src/plot.R data/data_train.csv img

train: data/data_test.csv data/data_train.csv
	python src/linear_model.py data/data_train.csv data/data_test.csv img/results_plot.png

all: img/age_dist.png img/correlation_plot.png img/country_dist.png img/heatmap_null.png img/weight_dist.png img/results_plot.png data/data_train.csv data/data_test.csv
	Rscript -e "rmarkdown::render('doc/final_report.Rmd')"

clean:
	rm -f data/raw_files/*.csv
	rm -f data/*.csv
	rm -f doc/final_report.html
	rm -f doc/final_report.md