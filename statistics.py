import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from sklearn.ensemble import RandomForestRegressor

data = pd.read_csv(
    'results/find-optimum-spreadsheet.csv',
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

init_sunflowers = np.array(data.loc[:, 'init-sunflowers'], dtype=np.int32)
sunflower_regrowth_time = np.array(data.loc[:, 'sunflower-regrowth-time'], dtype=np.int32)
init_cats = np.array(data.loc[:, 'init-cats'], dtype=np.int32)
cat_reproduce = np.array(data.loc[:, 'cat-reproduce'], dtype=np.int32)
gain_from_mouse = np.array(data.loc[:, 'gain-from-mouse'], dtype=np.int32)
init_mouses = np.array(data.loc[:, 'init-mouses'], dtype=np.int32)
mouse_reproduce = np.array(data.loc[:, 'mouse-reproduce'], dtype=np.int32)
gain_from_sunflower = np.array(data.loc[:, 'gain-from-sunflower'], dtype=np.int32)
steps = np.array(data.loc[:, '[steps]'], dtype=np.int32)
#count_mouses = np.array(data.loc[:, 'count-mouses'], dtype=np.int32)
#count_cats = np.array(data.loc[:, 'count-cats'], dtype=np.int32)
#count_sunflowers = np.array(data.loc[:, 'count-sunflowers'], dtype=np.int32)

# Get correlations
corr = []
corr.append(np.corrcoef(steps, init_sunflowers)[1, 0])
corr.append(np.corrcoef(steps, sunflower_regrowth_time)[1, 0])
corr.append(np.corrcoef(steps, init_cats)[1, 0])
corr.append(np.corrcoef(steps, cat_reproduce)[1, 0])
corr.append(np.corrcoef(steps, gain_from_mouse)[1, 0])
corr.append(np.corrcoef(steps, init_mouses)[1, 0])
corr.append(np.corrcoef(steps, mouse_reproduce)[1, 0])
corr.append(np.corrcoef(steps, gain_from_sunflower)[1, 0])
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
print(steps.shape)
rf.fit(X_train, steps)

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

idx = np.argmax(steps)
print(steps.max())
print(data.iloc[idx, :])

# Plot distribution of steps
fig, ax = plt.subplots(figsize=(8, 6))
idx = np.where(steps == 0)
steps_d = np.delete(steps, idx)
idx = np.where(steps_d == 1)
steps_d = np.delete(steps_d, idx)
_ = ax.hist(steps_d, bins='auto')
ax.set_xlabel('Steps')
ax.set_ylabel('Count')
ax.set_title('Distribution of steps')

# Mouse-Cat-Sunflower 3D space
#ax = fig.add_subplot(figsize=(8, 6), projection='3d')
#ax.plot3D(count_mouses, count_cats, count_sunflowers)
#ax.set_xlabel('Mouses')
#ax.set_ylabel('Cats')
#ax.set_zlabel('Sunflowers')
#ax.set_title('Mouse-Cat-Sunflower 3D space')

# show plots
plt.show()