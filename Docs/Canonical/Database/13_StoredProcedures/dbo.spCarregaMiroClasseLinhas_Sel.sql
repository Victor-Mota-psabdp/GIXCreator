SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spCarregaMiroClasseLinhas_Sel] -- [spCarregaMiroClasseLinhas_Sel] 'IMFMC201204004BR'
	@Num_Proc		VArchar(16)
	
AS

Declare @tmpNumeroFatura varchar(17)

Set @tmpNumeroFatura=(select MAx(fatura_pc) Linha from Fatura_CHB where processo_pc=@Num_PRoc and Cd_Tipo='P')

print @tmpNumeroFatura
		
Select Nome_Tp_Tx + ' - R$ ' + cast(cast(vlr_pc as decimal(10,2)) as vArchar(40)) Saida from Fatura_CHB_ITEM  FCI
Join FMC_Plano_Contas_V2 F on F.cd_tp_Tx=FCI.cd_Tp_TX 
Join Tipo_Taxa TT on TT.cd_tp_Tx=FCI.cd_Tp_Tx
Where Fatura_CC=@tmpNumeroFatura and ID_EVENTO='F'



GO
