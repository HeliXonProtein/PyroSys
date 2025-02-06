# PyroSys Architecture

PyroSys: A dynamic framework for PYthon based computational pROtein SYStems biology.

## Core Components

There are two part of one AI model:
1. The `Model` which is the model itself that holds the parameters and basic inference logic. Once you have a model, you can use it to make predictions.
2. The `Trainer` which is the part of how to get the model parameters from scratch. You DON'T need a `Trainer` to just use the `model`.

### Zen of PyroSys

1. The boundary between `Model` and `Trainer` is wheather you need to **build** the model or to **use** the model.

2. The core of PyroSys is to make **ProtoTypes** of the model. Complex inference method is not our focus.

3. The simplicity of PyroSys comes from separating **engineering** from **science**. You can focus on the science part only.

### Model

We use [`pl.LightiningModule`](https://lightning.ai/docs/pytorch/stable/common/lightning_module.html) to build the model. There are two main parts in the `Model`:

1. Module: The module is the basic building blocks of the model. Any module should be a `torch.nn.Module` and can be used in the `Model`. The flexibiltiy of PyroSys comes from the how we classify different `Modules`.

2. Adapter: The adapter is the part that loads the model parameters based on **Structure** rather than **parameter names**. This allow us to use the same weights in different models while keeping the module-level composition.

### Trainer

We use [`pl.Trainer`](https://lightning.ai/docs/pytorch/stable/common/trainer.html) or optionally [`Ray.Train`](https://docs.ray.io/en/latest/train/train.html) to train the model. For a seperation of **build** and **use** of the model, all losses and data sampling logics are implemented in the `Trainer`.

1. Dataloader: The dataloader is the part that loads the data from the dataset with some predefined sampling logics. If you are using PyroSys **without** default datasets, you should preprocess the data by yourself.

2. Training: Standard training API with infrastructures.

### Other Components

1. Loss and metrics: We set them apart from both the `Model` and `Trainer` because they are not related to use the model itself but are used in [`pl.LightiningModule`](https://lightning.ai/docs/pytorch/stable/common/lightning_module.html). This is a design choice to make the code more readable and maintainable.

2. Advanced model analysis based on [`mlflow`](https://www.mlflow.org/docs/latest/index.html).