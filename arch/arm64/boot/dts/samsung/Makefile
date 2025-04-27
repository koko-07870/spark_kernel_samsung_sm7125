ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)

ifeq ($(filter y,$(CONFIG_SEC_A52Q_PROJECT)),y)
# A52Q EUR
SEC_A52Q_EUR_DTBO := \
		atoll-sec-a52q-eur-overlay-r00.dtbo \
		atoll-sec-a52q-eur-overlay-r01.dtbo \
		atoll-sec-a52q-eur-overlay-r02.dtbo \
		atoll-sec-a52q-eur-overlay-r04.dtbo \
		atoll-sec-a52q-eur-overlay-r05.dtbo \
		atoll-sec-a52q-eur-overlay-r06.dtbo
endif
define __sec_dtbo_build
dtbo-$(2) += $(1)
$(1)-base := $(3)
endef

define sec_dtbo_build
$(foreach dtbo, $(1), $(eval $(call __sec_dtbo_build, $(dtbo),$(2),$(3))))
endef

# SM7125 BASE DTB
SEC_ATOLL_BASE_DTB := ../qcom/atoll-ab-idp.dtb

ifeq ($(filter y,$(CONFIG_SEC_A52Q_PROJECT)),y)
$(eval $(call sec_dtbo_build, \
		$(SEC_A52Q_EUR_DTBO),$(CONFIG_SEC_A52Q_EUR_OPEN),$(SEC_ATOLL_BASE_DTB)))
endif
endif

ifeq ($(CONFIG_ARM64),y)
always          := $(dtb-y)
subdir-y        := $(dts-dirs)
else
targets += dtbs
targets += $(addprefix ../, $(dtb-y))

$(obj)/../%.dtb: $(src)/%.dts FORCE
        $(call if_changed_dep,dtc)

dtbs: $(addprefix $(obj)/../,$(dtb-y))
endif

clean-files := *.dtb *.dtbo
