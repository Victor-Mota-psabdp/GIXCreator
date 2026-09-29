SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE       function FcEmbarques(
		@datainicial datetime,
		@datafinal   datetime,
		@cdPes	     varchar(10),
		@org	     varchar(3),
		@dst         varchar (3),
		@modal	     varchar(2)
)
RETURNS INT
BEGIN
		Declare @Saida Int


Set @Saida=IsNull(
		(Select count(num_proc_hia) Processo from house_imp_aer HOU
		Join Master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
		where (convert(datetime,dt_cheg_mia,105) between @datainicial and @datafinal or left(num_proc_hia,5)='IAREM' and convert(datetime,etd_hia,105)between @datainicial and @datafinal)and
		cd_org_hia=@org and cd_dst_hia=@dst and cd_import_hia=@cdpes 
		),0.00)
   	
Set @Saida=@Saida+IsNull(
		(Select count(num_proc_hea) Processo from house_exp_aer HOU
		Join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
		where convert(datetime,dt_saida_mea,105) between @datainicial and @datafinal and
		cd_org_hea=@org and cd_dst_hea=@dst and cd_export_hea=@cdpes
		),0.00)
   
Set @Saida=@Saida+IsNull(
   		(select count(num_proc_him) Processo from house_imp_mar hou
		Join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
		where convert(datetime,dt_atrac_mim,105) between @datainicial and @datafinal and
		cd_org_him=@org and cd_dst_him=@dst and cd_import_him=@cdpes
		),0.00)
Set @Saida=@Saida+IsNull(
   		(Select count(num_proc_heM) Processo from house_exp_mar HOU
		Join Master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
		where convert(datetime,dt_saida_mem,105) between @datainicial and @datafinal and
		cd_org_hem=@org and cd_dst_hem=@dst and cd_export_hem=@cdpes
		),0.00)
Return @Saida

ENd








GO
