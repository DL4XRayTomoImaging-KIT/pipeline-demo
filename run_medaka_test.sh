#!/bin/bash
# create a clean virtual environment
/usr/bin/python3 -m venv tmi_venv
source tmi_venv/bin/activate

# we need this before any other setups otherwise it fails
pip install wheel

# install and run bin-scaler
pip install git+https://github.com/DL4XRayTomoImaging-KIT/BinScale3D
mkdir tmp_data
python -m binscale.run --conversion-config=scale_convert.yml --data-config=medaka_52.yaml --multithread=2

# clone and run ML model inference
git clone -b test_inference git@github.com:DL4XRayTomoImaging-KIT/training-repo.git
cd training-repo
pip install -r requirements.txt
python inference.py +model=brain +dataset=test_data +checkpoint=brain
cd ../

# clone and run post-processing and cleaning
git clone -b test_branch git@github.com:DL4XRayTomoImaging-KIT/post-proceessing-repo.git
cd post-proceessing-repo
python process.py --conversion-config=configs/brain_cleaning.yml --data-config=configs/test_data.yml --multithread=2
cd ../

# this workaround is here becaus of how Medaka files are typically organized on LSDF
ls tmp_data/postprocessed_* -1 | grep -oP "Medaka_\K\d{3}" | while read n; do 
	mkdir tmp_data/Medaka_"$n";
	cp tmp_data/postprocessed_segmented_scaled_0.5_uint8_Medaka_"$n"_39-2.tif.tif tmp_data/Medaka_"$n"/postprocessed_segmented_scaled_0.5_uint8_slices.tif
	cp tmp_data/scaled_0.5_uint8_Medaka_"$n"_39-2.tif.tif tmp_data/Medaka_"$n"/scaled_0.5_uint8_slices.tif
done
# end of the workaround

# clone and run measurement
git clone -b test_branch git@github.com:DL4XRayTomoImaging-KIT/measuring-repo.git
cd measuring-repo
pip install -r requirements.txt
python measure.py +dataset=test_brain +measurement=brain +processing=test_db
cd ../
