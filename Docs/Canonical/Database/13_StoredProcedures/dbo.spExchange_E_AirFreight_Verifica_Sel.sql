SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spExchange_E_AirFreight_Verifica_Sel  'EAGRU201606019' 
--select [07_Air Company] from [dbo].[vwHEA_Sel]
--select [08 Carrier Name] from [dbo].[vwMasterEA_Sel] where [01 BDP Reference] = 'EAGRU201606019'  

--AA - AMERICAN AIRLINES
--BA - BRITISH AIRWAYS
--AF - AIR FRANCE
--LH - LUFTHANSA
--select * from Cia_Aerea where cd_Cia_Aer = 'sw'
--update Cia_Aerea set Prefix=172 where cd_Cia_Aer = 'CV'
--select * from Cia_Aerea where EfreightDescartes =1
--update Cia_Aerea set EfreightDescartes = 1 where cd_Cia_Aer in ('AA','BA','LH','AF','CV','TKU')
--update Cia_Aerea set EfreightDescartes = 1 where cd_Cia_Aer in ('SW')
--alter table [dbo].[Cia_Aerea] add EfreightDescartes bit NULL

CREATE Procedure [dbo].[spExchange_E_AirFreight_Verifica_Sel]--'EAATL201601001BR'
(
	@Num_Proc	varchar(16)
)
as

if LEN(@Num_Proc) = 16
	BEGIN
		if exists(select CA.Nome_Cia_Aer from house_exp_Aer HOU			
			Join LLP_Exp_Aer LLP on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
			Join Cia_Aerea CA on LLP.cd_ciaAerea_lea = CA.cd_cia_aer
		Where 
			Num_Proc_HEA = @Num_Proc and isnull(CA.EfreightDescartes,0) = 0)
		--if exists(select [07_Air Company] from [dbo].[vwHEA_Sel] where [07_Air Company] not in 
		--('AMERICAN AIRLINES','BRITISH AIRWAYS','AIR FRANCE','LUFTHANSA') and [01_BDP Reference] = @Num_Proc)
			select [01_BDP Reference] from [dbo].[vwHEA_Sel] where [01_BDP Reference] = @Num_Proc
		else
			Select Num_Proc_Hea from Exchange_E_AirFreight where Num_Proc_Hea = @Num_Proc
	END
ELSE
	BEGIN

		if exists(select CA.Nome_Cia_Aer from Master_Exp_Aer MEA 
			Join LLP_Master LLP on MEA.num_proc_mea = LLP.Num_Proc_master	
			Join Cia_Aerea CA on MEA.cd_cia_aer = CA.cd_cia_aer
		Where 
			MEA.Num_Proc_mea=@Num_Proc and isnull(CA.EfreightDescartes,0) = 0)
		--if exists(select [08 Carrier Name] from [dbo].[vwMasterEA_Sel] where [08 Carrier Name] not in 
		--('AMERICAN AIRLINES','BRITISH AIRWAYS','AIR FRANCE','LUFTHANSA') and [01 BDP Reference] = @Num_Proc)

			select [01 BDP Reference] from [dbo].[vwMasterEA_Sel] where [01 BDP Reference] = @Num_Proc
		else
			Select Num_Proc_Mea from Exchange_E_AirFreight where Num_Proc_Mea = @Num_Proc
	
	END
	

--if LEN(@Num_Proc) = 16	
--		Select Num_Proc from vwClienteALLJOBS where Num_Proc = @Num_Proc
--	else
--		Select Num_Proc from vwClienteALLJOBS where Master = @Num_Proc
	
	




GO
