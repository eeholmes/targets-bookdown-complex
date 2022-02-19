tar_target(fit, {
  biglm(Ozone ~ -1 + Wind + Temp, data)
})
