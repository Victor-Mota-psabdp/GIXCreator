SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spBuscaUltimoDtContainer_Sel]-- 'IMWAL20091002801'
		@Num_proc	Varchar(16)

as

select top 1 convert(datetime, dt_devol_im,103) dt_devol_im from container_hou_imp_mar CH
Join Container_Mas_Imp_mar CM on CM.num_proc_mim=CH.num_proc_mim and CM.item_cont_im=CH.item_cont_im
where 
	num_proc_Him=@num_proc
order by
	dt_devol_im desc





GO
