SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















CREATE function [dbo].[spRateio_Mas_PesoQuantidade]
			(@Num_Proc varchar(16),
			@tipo char(1)
			)

returns
	Float
as
	Begin
		Declare @Qtd FLOAT
		Declare @Num_Master varchar(14)
		Declare @PesoHouse	float
		Declare @PesoMaster float
		
		
		Set @Num_master =(select [master] from vwcliente with(nolock) where num_proc=@Num_Proc and [master]<>'JOB')
		if @Num_Master is null 
			Begin
				return 1
			End
		set @qtd= (select count(*) from vwcliente with(nolock) where master=@num_Master)
		if @QTD is null or @QTD=1
			begin
				REturn 1
			End
		Else
			begin
				if @tipo='H' 
					Begin
						return((1.00/@qtd))
					End
				else
					Begin
						if left(@Num_proc,2)='IA' 
							Begin
								Set @PesoMaster=(select peso_bruto_mia from master_imp_aer with(nolock)	where num_proc_mia=@Num_master)
									if @PesoMaster is null or @PesoMaster=0
										Begin
										
											Return (1.00)
										
										End					
									Else
										Begin
											set @PesoHouse=(select peso_bruto_hia from house_imp_aer with(nolock)	where num_proc_hia=@num_proc)
											if @PesoHouse is null
												Begin
										
													Return (1.00)
										
												End					
											else
												BEgin
													return(@PesoHouse/@PesoMaster)
												End
										
										End
									
							End
														if left(@Num_proc,2)='IM' 
							Begin
								Set @PesoMaster=(select peso_bruto_mim from master_imp_mar with(nolock)	where num_proc_mim=@Num_master)
									if @PesoMaster is null or @PesoMaster=0
										Begin
										
											Return (1.00)
										
										End					
									Else
										Begin
											set @PesoHouse=(select peso_bruto_him from house_imp_mar with(nolock)	where num_proc_him=@num_proc)
											if @PesoHouse is null
												Begin
										
													Return (1.00)
										
												End					
											else
												BEgin
													return(@PesoHouse/@PesoMaster)
												End
										
										End
									
							End
							if left(@Num_proc,2)='EA' 
							Begin
								Set @PesoMaster=(select peso_bruto_mea from master_exp_aer with(nolock)	where num_proc_mea=@Num_master)
									if @PesoMaster is null or @PesoMaster=0
										Begin
										
											Return (1.00)
										
										End					
									Else
										Begin
											set @PesoHouse=(select peso_bruto_hea from house_exp_aer with(nolock)	where num_proc_hea=@num_proc)
											if @PesoHouse is null
												Begin
										
													Return (1.00)
										
												End					
											else
												BEgin
													return(@PesoHouse/@PesoMaster)
												End
										
										End
									
							End

							if left(@Num_proc,2)='EM' 
							Begin
								Set @PesoMaster=(select peso_bruto_mem from master_exp_mar with(nolock)	where num_proc_mem=@Num_master)
									if @PesoMaster is null or @PesoMaster=0
										Begin
										
											Return (1.00)
										
										End					
									Else
										Begin
											set @PesoHouse=(select peso_bruto_hem from house_exp_mar with(nolock)	where num_proc_hem=@num_proc)
											if @PesoHouse is null
												Begin
										
													Return (1.00)
										
												End					
											else
												BEgin
													return(@PesoHouse/@PesoMaster)
												End
										
										End
									
							End
					
				
					End
	
			End
		
			return 1
		End
		
		
GO
