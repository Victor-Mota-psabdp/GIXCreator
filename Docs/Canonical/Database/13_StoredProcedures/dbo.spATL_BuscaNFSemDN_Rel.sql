SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_BuscaNFSemDN_Rel]-- [dbo].[spATL_BuscaNFSemDN_Rel] '2015-01-01','2015-08-30'
	@DataInicial Datetime,
	@DataFinal Datetime
	
as	

SET NOCOUNT ON
/* Rafael 07/06/2017 - alterado para a View vwFaturasValidas
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
				fatdtEmissao >='01-01-2013' and fatstatus =1
	End	
*/
	
---select * from @Fatura
		select  
			Nome_Usuario [Criado por],
			nota_fiscal [Nota Fiscal],
			codigo		[Tipo],
			IA.num_proc	[Job],
			convert(varchar,emissao,105) [Emissao]	 
		from 
			base_nota_fiscal NF with(nolock)
		Join Fatura_ARG		 FA	with(nolock) on FA.numero=nf.notA_fiscal and codigo=ref_acesso
		Join fatura_Arg_det  IA with(nolock) on IA.id_Fat=FA.id_Fat
		--Left Join @Fatura FAt  on fat.num_proc=IA.num_proc and IA.cd_tp_Tx=FAt.cd_tp_tx and IA.dc=fat.dc
		Left Join dbo.vwFaturasValidas FAT with(nolock) on fat.num_proc=IA.num_proc and IA.cd_tp_Tx=FAt.cd_tp_tx and IA.dc=fat.dc
		Join usuario		 US with(nolock) on US.cd_usuario=Nf.cd_usuario
		where
		Fat.num_proc is null
		and cd_status <>2
		and emissao between @datainicial and @dataFinal
		and left(IA.num_proc,5) <> 'IAREM'
		and NF.nota_fiscal <> '47130'
		
	order by Nome_Usuario,[Emissao]

OPTION(HASH JOIN)
GO
