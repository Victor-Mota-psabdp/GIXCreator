SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function spVerificaItensEmAberto_Sel ---select dbo.spVerificaItensEmAberto_Sel ('IMCSR201201001BR')
		(
		@Job Varchar(16)
	)
Returns bit

AS

Begin
	Declare @Table Table
			(
				Num_Proc Varchar(16)
				
			)
		insert @table values(@Job)
		

		if left(@Job,2)='IM'
			Begin			
				Insert @table		
				select num_proc_him from house_imp_mar with(nolock) where num_proc_mim=@Job
			End			
		if left(@Job,2)='EM'
			Begin			
				Insert @table		
				select num_proc_hem from house_exp_mar with(nolock) where num_proc_mem=@Job
			End
		if left(@Job,2)='IA'
			Begin			
				Insert @table		
				select num_proc_hia from house_imp_aer with(nolock) where num_proc_mia=@Job
			End
		if left(@Job,2)='EA'
			Begin			
				Insert @table		
				select num_proc_hea from house_exp_aer with(nolock) where num_proc_mea=@Job
			End
			
	if exists(	
	select * from vwcta_Cte CTA
	Left Join vwCXAs CXA on cta.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=CXA.dc_hia
	Join @Table on Num_Proc=cta.num_proc_hia
	where num_lcto is null
	)
		BEgin
				return 1 
		End
	Else
		Begin
				Return 0
		End
	return 0
End
GO
