import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.ensemble import RandomForestRegressor

data = pd.read_csv(
    'cv1 find-optimum-spreadsheet_9.csv',
    index_col=0,
    sep=',',
    quotechar='"',
    header=None,
    on_bad_lines='warn',
    low_memory=False,
).T
print(data)

print(data.iloc[0, :])
print(data.iloc[-1, :])

init_sunflowers = np.array(data.iloc[:, 1].tolist(), dtype=np.int32)
sunflower_regrowth_time = np.array(data.iloc[:, 2].tolist(), dtype=np.int32)
init_cats = np.array(data.iloc[:, 4].tolist(), dtype=np.int32)
cat_reproduce = np.array(data.iloc[:, 5].tolist(), dtype=np.int32)
gain_from_mouse = np.array(data.iloc[:, 7].tolist(), dtype=np.int32)
init_mouses = np.array(data.iloc[:, 8].tolist(), dtype=np.int32)
mouse_reproduce = np.array(data.iloc[:, 10].tolist(), dtype=np.int32)
gain_from_sunflower = np.array(data.iloc[:, 11].tolist(), dtype=np.int32)
t = np.array(data.iloc[:, 13].tolist(), dtype=np.int32)

# Get correlations
corr = []
corr.append(np.corrcoef(t, init_sunflowers)[1, 0])
corr.append(np.corrcoef(t, sunflower_regrowth_time)[1, 0])
corr.append(np.corrcoef(t, init_cats)[1, 0])
corr.append(np.corrcoef(t, cat_reproduce)[1, 0])
corr.append(np.corrcoef(t, gain_from_mouse)[1, 0])
corr.append(np.corrcoef(t, init_mouses)[1, 0])
corr.append(np.corrcoef(t, mouse_reproduce)[1, 0])
corr.append(np.corrcoef(t, gain_from_sunflower)[1, 0])
corr = np.array(corr)

# Plot correlations as bar chart
fig, ax = plt.subplots(figsize=(8, 6))
x = np.arange(8)
mask1 = corr < 0
mask2 = corr > 0
colors = np.array(['b']*len(x))
colors[mask1] = 'r'
colors[mask2] = 'g'
rects1 = ax.barh(x, corr, 0.35, color=colors)
ax.set_xlabel('Correlation')
ax.set_title('Correlation between hyperparameters and time of simulation')
ax.set_yticks(x, [
    "init_sunflowers", 
    "sunflower_regrowth_time",
    "init_cats",
    "cat_reproduce",
    "gain_from_mouse",
    "init_mouses",
    "mouse_reproduce",
    "gain_from_sunflower",
])
ax.bar_label(rects1, padding=2, fmt='%.3f')
fig.tight_layout()
#plt.show()

# Get importance
rf = RandomForestRegressor(n_estimators=100)
X_train = np.column_stack((
    init_sunflowers, 
    sunflower_regrowth_time,
    init_cats,
    cat_reproduce,
    gain_from_mouse,
    init_mouses,
    mouse_reproduce,
    gain_from_sunflower,
))
print(X_train.shape)
print(t.shape)
rf.fit(X_train, t)

# Plot importance as bar chart
fig, ax = plt.subplots(figsize=(8, 6))
x = np.arange(8)
rects1 = ax.barh(x, rf.feature_importances_, 0.35, color='b')
ax.set_xlabel('Importance')
ax.set_title('Importance of hyperparameters')
ax.set_yticks(x, [
    "init_sunflowers", 
    "sunflower_regrowth_time",
    "init_cats",
    "cat_reproduce",
    "gain_from_mouse",
    "init_mouses",
    "mouse_reproduce",
    "gain_from_sunflower",
])
ax.bar_label(rects1, padding=2, fmt='%.3f')
fig.tight_layout()
plt.show()

idx = np.argmax(t)
print(t.max())
print(data.iloc[idx, :])