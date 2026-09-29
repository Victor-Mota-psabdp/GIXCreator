SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from base_nota_fiscal where notA_fiscal = 47710 and ref_acesso =  'A'
--select * from Fatura_ARG where numero=47710 and codigo='A'
--select * from fatura_Arg_det where id_fat = 55890
--select * from cta_cte_hou_imp_aer where num_proc_hia = 'iatar201308002br'
--select * from item_fat where num_proc = 'iatar201308002br'
--select * from fatura where fatcod = 'IATAR201308002BRA'


CREATE Procedure [dbo].[spBuscaNFcomDN_Sel]--47710,'A'
	@Nota_fiscal Varchar(10),
	@Ref_Acesso		char(1)
	
as	

SET NOCOUNT ON
Declare @Fatura Table
		(
			Num_proc	varchar(16),
			FatCod		varchar(17),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)			
		)
	Begin 		
		Insert @Fatura			
			Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
			i.fatcod,
			cd_tp_Tx,dc from item_fat I	with(nolock)			
				Join Fatura F with(nolock) on F.fatcod=i.fatcod 
			where
--				num_proc = 'iatar201308002br' and
				fatdtEmissao >='07-01-2013' 
				and fatstatus =1
	End		

	select 
		nota_fiscal,IA.num_proc Num_Proc, nome_tp_tx Taxa
	from base_nota_fiscal NF with(nolock)
		Join Fatura_ARG FA with(nolock) on FA.numero=nf.notA_fiscal and codigo=ref_acesso and cd_status <> 2
		Join fatura_Arg_det IA with(nolock) on IA.id_Fat=FA.id_Fat
		left join tipo_taxa TT with(nolock) on TT.cd_tp_tx = IA.cd_tp_tx
		left Join @Fatura FAt on fat.num_proc=IA.num_proc and FAt.cd_tp_tx =IA.cd_tp_Tx and fat.dc=IA.dc	
	where
		nf.notA_fiscal = @Nota_fiscal
		and ref_acesso =  @Ref_Acesso		
		and emissao >='08-01-2013'
		and fat.fatcod is not null

GO
