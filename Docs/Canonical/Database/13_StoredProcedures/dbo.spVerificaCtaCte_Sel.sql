SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from VWCta_Cte where Num_Proc_HIA = 'IMEAS201302003BR' and cd_tp_tx = 'BRO' and DC_hia ='C'
--select * from pessoa where cd_pes = 'P000002211'
--[spVerificaCtaCte_Sel] 'IMEAS201302003BR','XBA','C','EASTMAN C. DO BRASIL'
--[spVerificaCtaCte_Sel] 'IMEAS201302003BR','BRO','C','EASTMAN C. DO BRASIL'
--[spVerificaCtaCte_Sel] 'IMEAS201302003BR','BRO','C','TESTE'
CREATE procedure [dbo].[spVerificaCtaCte_Sel]
(
	@Num_Proc varchar(16),
	@Cd_Tp_Tx varchar(3),
	@DC char(1),
	@Cd_Cred_Dev varchar(20)
)
as
--select Num_Proc_HIA Num_Proc,Cd_Tp_Tx,DC_HIA DC from VWCta_Cte 

--where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = @DC

Declare @Temp Table(
			Num_CPF_CNPJ VARCHAR(15),
			Fatura varchar(17),
			Num_Proc varchar(16),
			Cd_Tp_Tx varchar(3),
			DC char(1)
			)
			
insert into @Temp
select PS.Num_CPF_CNPJ, 
(Select max(FatCod) from item_Fat FAT with(nolock) 
where FAT.Num_Proc = VW.num_proc_hia and FAT.cd_tp_tx = VW.cd_tp_tx and FAT.DC = VW.dc_hia and FAT.FatCod in (select fatcod from fatura with(nolock) where fatcod=fat.fatcod and fatstatus='1')) Fatura,
 VW.Num_Proc_HIA Num_Proc,VW.Cd_Tp_Tx,VW.DC_HIA DC from VWCta_Cte VW with(nolock)
left join Pessoa PS with(nolock) on VW.Cd_Cred_Dev_HIA = PS.Cd_Pes
where Vw.Num_Proc_HIA =@Num_Proc  and Vw.Cd_Tp_Tx = @Cd_Tp_Tx and Vw.DC_HIA = @DC
--print 1
--Select * from @Temp
Declare @Num_CPF_CNPJ varchar(15)
Set @Num_CPF_CNPJ = (select Num_CPF_CNPJ from Pessoa with(nolock) where Cd_Pes = @Cd_Cred_Dev)

If EXISTS (select Fatura from @Temp where Fatura is not NULL AND Num_CPF_CNPJ = @Num_CPF_CNPJ )
	Begin
		--print 2
		--Select * from @Temp
		DELETE @Temp

	END
	
--print 3
Select * from @Temp

GO
