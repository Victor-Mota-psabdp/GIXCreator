SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spMasterBDP_Sel 'IABUE201112002','New York (JFK)','Buenos Aires' 
--mudado pra verificar o modal por causa da gra q cadastrou aeroporto no local do porto
--ANTONIO 13-06-2024 alterado para trazer um periodo de 2 anos, estoura o listview do vb (27.000 linhas no maximo) 
--and convert(datetime, HOU.Dt_Emis_HIM,103)> GETDATE()-720

CREATE PROCEDURE [dbo].[spMasterBDP_Sel] --'Yantian','SANTOS'
(
@Master		varchar(14),
@Origem		varchar(30),
@Destino	varchar(30)
)
AS

	Begin

		Declare @Cd_Origem	varchar(10)
		Declare @Cd_Destino	varchar(10)

		Set @cd_origem	=(select top 1 cd_local from localidade where Nome_Local=@Origem)
		Set @cd_destino	=(select top 1 cd_local from localidade where Nome_Local=@Destino)

		if @Origem is not null and @Destino is not null

			BEGIN
				if left(@Master,2)='IM'
					Begin
						Select Num_Proc_LIM JOB From LLP_Imp_Mar  LLP
							Left Join House_Imp_Mar	HOU on HOU.Num_Proc_HIM	= LLP.Num_Proc_LIM
						Where
							HOU.Cd_Org_HIM = @cd_origem and HOU.Cd_Dst_HIM = @cd_destino
							and Num_Proc_LIM in (Select Num_Proc_HIM from House_Imp_Mar where num_proc_mim ='JOB')
                            and convert(datetime, HOU.Dt_Emis_HIM,103)> GETDATE()-720  
					End
				if left(@Master,2)='IA'
					Begin
						Select Num_Proc_LIA JOB From LLP_Imp_Aer  LLP
							Left Join House_Imp_Aer	HOU on HOU.Num_Proc_HIA	= LLP.Num_Proc_LIA
						Where
							HOU.Cd_Org_HIA = @cd_origem and HOU.Cd_Dst_HIA = @cd_destino
							and Num_Proc_LIA in (Select Num_Proc_HIA from House_Imp_Aer where num_proc_mia ='JOB')
                            and convert(datetime, HOU.Dt_Emis_HIA,103)> GETDATE()-720  
					End
				
				if left(@Master,2)='EM'
					Begin
						Select Num_Proc_LEM JOB From LLP_Exp_Mar  LLP
							Left Join House_Exp_Mar	HOU on HOU.Num_Proc_HEM	= LLP.Num_Proc_LEM
						Where
							HOU.Cd_Org_HEM = @cd_origem and HOU.Cd_Dst_HEM = @cd_destino
							and Num_Proc_LEM in (Select Num_Proc_HEM from House_Exp_Mar where num_proc_mem ='JOB')
                            and convert(datetime, HOU.Dt_Emis_HEM,103)> GETDATE()-720  
					End
				if left(@Master,2)='EA'
					Begin
						Select Num_Proc_LEA JOB From LLP_Exp_Aer  LLP
							Left Join House_Exp_Aer	HOU on HOU.Num_Proc_HEA	= LLP.Num_Proc_LEA
						Where
							--HOU.Cd_Org_HEA = @cd_origem and HOU.Cd_Dst_HEA = @cd_destino
							Num_Proc_LEA in (Select Num_Proc_HEA from House_Exp_Aer where num_proc_mea ='JOB')
                            and convert(datetime, HOU.Dt_Emis_HEA,103)> GETDATE()-720  
					End
			END
		Else
			if left(@Master,2)='IM' 
				Begin
					Select Num_Proc_HIM JOB from House_Imp_Mar where Num_proc_MIM=@Master
				End
			else if left(@Master,2)='IA' 
				Begin
					Select Num_Proc_HIA JOB from House_Imp_Aer where Num_proc_MIA=@Master
				End
			else if left(@Master,2)='EM' 
				Begin
					Select Num_Proc_HEM JOB from House_Exp_Mar where Num_proc_MEM=@Master
				End
			else if left(@Master,2)='EA' 
				Begin
					Select Num_Proc_HEA JOB from House_Exp_Aer where Num_proc_MEA=@Master
				End




	End


GO
