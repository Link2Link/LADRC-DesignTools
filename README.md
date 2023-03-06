# LADRC-DesignTools
Matlab script for LADRC controller design.
 
## Getting Started

with given Plant (dynamic system), required crossover frequency wf and phase margin PM, the function give back the parameter for the first/second order LADRC controller. 

```
[wo, wc, b0] = DesignLADRC1(P, wf, PM)
[wo, wc, b0] = DesignLADRC2(P, wf, PM)
```

please check the "demo_1st_LADRC.mlx" and "demo_2ed_LADRC.mlx" for more details.

## Reference

If you're interested in the theory behind it, please check the video

https://www.bilibili.com/video/BV1UD4y117yB/?spm_id_from=333.337.search-card.all.click&vd_source=bb3bd5d4d1c0ae294f37619d99877ae1