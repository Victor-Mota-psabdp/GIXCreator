SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spVerificaNF_MesAnterior]--'IMATL201306181BRB'
	@FATCOD	Varchar(17)
	
as	

SET NOCOUNT ON

Declare @Fatura Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)			
		)
	Begin 		
		Insert @Fatura	
			
			Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
			cd_tp_Tx,dc from item_fat I with(nolock)				
				Join Fatura F with(nolock) on F.fatcod=i.fatcod 
			where
				F.fatcod = @FATCOD
				and fatstatus =1
	End	
	
select  
	distinct NF.emissao,NF.nota_fiscal,codigo,IA.num_proc Num_Proc
from 
	base_nota_fiscal NF with(nolock)
Join Fatura_ARG FA with(nolock) on FA.numero=nf.notA_fiscal and codigo=ref_acesso
Join fatura_Arg_det IA with(nolock) on IA.id_Fat=FA.id_Fat
Join @Fatura FAt on fat.num_proc=IA.num_proc and IA.cd_tp_Tx=FAt.cd_tp_tx and IA.dc=fat.dc
where
cd_status <>2
and left(IA.num_proc,5) <> 'IAREM'
GO
