SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spAtualizaDtDevolContainer_Upd
	@Container Varchar(50),
	@DI			Varchar(30),
	@Data		Datetime

as


update Container_Mas_Imp_Mar set dt_devol_im=convert(varchar(10),@data,103) From Container_Mas_Imp_mar CM with(nolock)
Join Container_Hou_Imp_Mar CH with(nolock) on CH.num_proc_mim=CM.num_proC_mim and CH.item_cont_im=CM.item_cont_im
Join PO_HIM DI with(nolock) on CH.num_proc_him=di.num_proc_him and id_dc=5
Join LLP_Imp_MAr with(nolock) on num_proc_lim=CH.num_proc_him
where
	Num_Cont_IM=@Container and Numero_PO_HIM=@DI
	and cd_Tp_carga=1	and dt_devol_im is null
	and @Data > ATA_LIM
GO
