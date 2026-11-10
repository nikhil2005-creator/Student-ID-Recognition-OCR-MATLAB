# Student ID Recognition using OCR and DSP (MATLAB)

A MATLAB project that reads a student's **SRN** from an ID card using a webcam.
It cleans up the image with digital signal processing techniques, reads the
text with OCR, and looks the SRN up in a student database to display that
student's details.

*DSP Jackfruit-level problem*

---

## Team members

| Name | SRN |
|---|---|
| Pruthvi | PES1UG23EC230 |
| Rakesh DN | PES1UG24EC808 |
| Nikhil Babu | PES1UG23EC200 |
| Nikhil N | PES1UG23EC203 |

---

## Problem statement

To detect the text (SRN) using digital signal processing and display the
respective details of the student using MATLAB.

---

## Tools

1. MATLAB
2. Webcam
3. Image Processing Toolbox
4. Signal Processing Toolbox
5. Computer Vision Toolbox (for OCR)

---

## Repository structure

```
├── code/
│   └── DSPjackfruit.m          # main script: webcam → preprocessing → OCR → database lookup
├── database/
│   └── create_studentDB.m      # builds studentDB.mat (student records)
├── simulation_results/         # input images, OCR images and MATLAB outputs
├── docs/
│   └── formulas/               # formula images used in the explanation below
└── README.md
```

---

## How it works

```
Webcam snapshot → Grayscale → Median filter → Sharpen → Contrast adjust
→ Resize (×2) → Adaptive binarization → Median filter → OCR → Database lookup
```

1. The script captures an image from the webcam.
2. The image goes through the preprocessing steps below so the text is clear.
3. OCR reads the text. It only accepts the characters `A–Z` and `0–9`.
4. If the detected text matches an SRN in the database, the student's name,
   course, year and phone number are displayed.
5. If nothing is detected or the SRN isn't in the database, the script tries
   again, up to **10 attempts**.

---

## Formulas used

### 1. Grayscale conversion
![Grayscale](docs/formulas/1-grayscale.png)

This is a weighted sum that converts RGB values into grayscale intensity
(`rgb2gray`).

### 2. Median filtering (noise reduction)
For each 3×3 neighbourhood:
1. Collect all 9 pixel values.
2. Sort them.
3. Take the median (middle value).

Example:
```
input : [34, 120, 56, 98, 240, 130, 75, 45, 67]
sorted: [34, 45, 56, 67, 75, 98, 120, 130, 240]
median: 75
```
Implemented with `medfilt2`.

### 3. Sharpening (image enhancement)
![Sharpening](docs/formulas/2-sharpening.png)

This is a high-pass filter approximation. α controls the level of sharpening,
commonly between 0.2 and 1 (`imsharpen`).

### 4. Contrast adjustment
![Contrast adjustment](docs/formulas/3-contrast_adjustment.png)

This scales pixel intensities to the full range [0, 255]. I<sub>min</sub> and
I<sub>max</sub> are the minimum and maximum grayscale values in the image
(`imadjust`).

### 5. Thresholding / binarization
Adaptive threshold:

![Adaptive threshold](docs/formulas/4-adaptive_threshold.png)

Where:
- μ(x, y) is the local mean
- σ(x, y) is the local standard deviation
- R is the dynamic range of the standard deviation
- k is a tuning parameter (e.g. 0.3–0.5)

Each pixel:

![Binarization](docs/formulas/5-binarization.png)

Implemented with `imbinarize(..., 'adaptive', 'Sensitivity', 0.4)`.

---

## How to run

1. Install MATLAB with the Image Processing, Signal Processing and Computer
   Vision toolboxes, plus the **MATLAB Support Package for USB Webcams**.
2. Connect a webcam. A phone camera through an app such as Iriun Webcam also works.
3. Open the `code/` folder in MATLAB.
4. Optional: run `database/create_studentDB.m` from that folder to create
   `studentDB.mat`. If the file doesn't exist, the main script creates it
   automatically.
5. Run `DSPjackfruit.m` and hold the ID card (SRN) in front of the camera.

> Phone numbers in this repository are replaced with placeholders
> (`xx`, `yy`, `zz`, `aa`) for privacy.

---

## Results

### Test 1: Registered student (`PES1UG23EC230`)

| Input | Image used for OCR |
|---|---|
| <img src="simulation_results/input1_PES1UG23EC230.jpeg" width="150"> | <img src="simulation_results/ocr_image1.jpeg" width="500"> |

Output: the SRN is detected on attempt 3 and the student's details are displayed.

<img src="simulation_results/output1_student_found.jpeg" width="500">

### Test 2: Unregistered SRN (`PES1UG23EC300`)

| Input | Image used for OCR |
|---|---|
| <img src="simulation_results/input2_PES1UG23EC300.jpeg" width="150"> | <img src="simulation_results/ocr_image2.jpeg" width="500"> |

Output: the SRN is detected correctly but isn't in the database, so the script
reports **"Not a valid student ID"** and keeps retrying.

<img src="simulation_results/output2_not_a_student.jpeg" width="500">

---

## Conclusion

This MATLAB script combines webcam input and OCR to identify students from
their ID cards. Image preprocessing techniques improve text recognition
accuracy. The Image Processing, Signal Processing and Computer Vision toolboxes
provide the processing and OCR functions. A student database is used to verify
the SRN and display the student's details when detection succeeds.

If the detected text doesn't match any entry in the database, the output says
it's not a valid student. If a student belongs to the college but isn't
detected, their SRN has to be registered in the database. The system shows an
efficient method for automated student identification using real-time image
capture.
