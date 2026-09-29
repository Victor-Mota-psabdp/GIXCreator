SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[spDemurrageControl_Sel]--'IMAET201506001BR'
		@Num_Proc varChar(16)

as
select isnull(convert(char(10),ATA_Master,103),'') ATRAC, Navio_him Navio,
	pp.Apelido
	from House_Imp_Mar HOU With(nolock) 
	join LLP_Master LLP With(nolock)  on LLP.Num_Proc_Master = HOU.Num_Proc_MIM
	Join Master_Imp_Mar	MIM With(nolock)  on MIM.Num_Proc_MIM = HOU.Num_Proc_MIM
	join Pessoa PP With(nolock)  on PP.Cd_Pes = hou.Cd_Consig_HIM
where
	HOU.Num_Proc_HIM = @Num_Proc
	
	
--select 
--	isnull(convert(char(10),ATA_Master,103),'') ATRAC,
--	Navio_him Navio 
--from 
--	llp_master LLP With(nolock)  
--	left outer join house_imp_mar HIM With(nolock) on HIM.num_proc_him = 'IMAET201506001BR' 
--where 
--	num_proc_master=(select num_proc_mim from house_imp_mar With(nolock) where num_proc_him='IMAET201506001BR') 
--Union ALL 
--	select isnull(dt_atrac_mim,'') ATRAC,Navio_mim Navio 
--	from master_imp_mar With(nolock) 
--	where 
--	num_proc_mim=(select num_proc_mim from house_imp_mar With(nolock) where num_proc_him='IMAET201506001BR' ) 
GO
