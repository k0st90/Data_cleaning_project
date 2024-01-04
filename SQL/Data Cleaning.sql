/*

DATA CLEANING

*/

------------------------------------

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Data_Cleaning..NashvilleHousing

ALTER TABLE Data_Cleaning..NashvilleHousing
ADD SaleDateConverted DATE

UPDATE Data_Cleaning..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------

SELECT PropertyAddress
FROM Data_Cleaning..NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Data_Cleaning..NashvilleHousing AS A
JOIN Data_Cleaning..NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.UniqueID != B.UniqueID
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Data_Cleaning..NashvilleHousing AS A
JOIN Data_Cleaning..NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.UniqueID != B.UniqueID

----------------------------------------

SELECT PropertyAddress
FROM Data_Cleaning..NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM Data_Cleaning..NashvilleHousing

ALTER TABLE Data_Cleaning..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

ALTER TABLE Data_Cleaning..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE Data_Cleaning..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE Data_Cleaning..NashvilleHousing
SET  PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM Data_Cleaning..NashvilleHousing




SELECT OwnerAddress
FROM Data_Cleaning..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Data_Cleaning..NashvilleHousing

ALTER TABLE Data_Cleaning..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

ALTER TABLE Data_Cleaning..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

ALTER TABLE Data_Cleaning..NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE Data_Cleaning..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE Data_Cleaning..NashvilleHousing
SET  OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE Data_Cleaning..NashvilleHousing
SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM Data_Cleaning..NashvilleHousing

----------------------------------

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM Data_Cleaning..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'NO' ELSE SoldAsVacant END
FROM Data_Cleaning..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'NO' ELSE SoldAsVacant END
FROM Data_Cleaning..NashvilleHousing


-----------------------------------------

WITH RowNUMCTE AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY
ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID) AS row_num
FROM Data_Cleaning..NashvilleHousing
)
DELETE
FROM RowNUMCTE
WHERE row_num > 1


-------------------------------------

ALTER TABLE Data_Cleaning..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate