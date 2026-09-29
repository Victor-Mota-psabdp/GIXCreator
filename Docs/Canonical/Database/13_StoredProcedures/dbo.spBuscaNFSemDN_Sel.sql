SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from base_nota_fiscal where nota_fiscal = 48573
--select * from Fatura_ARG where numero = 48573
--select * from fatura_arg_det where left(num_proc,5)= 'IAREM'
--id_fat = 56778
--select * from tipo_taxa where cd_tp_tx = 'ADG'
--select * from house_imp_aer where num_proc_hia = 'IAREM201209031'
--select * from usuario where nome_usuario like 'lucas%'
--Incluida pra nao verificar uma nf da Aline - autorizado pelo Financeiro
--Incluida pra nao verificar uma nf da Aa Cunha de 2013 - autorizado pelo Financeiro/Siberio--
--Erbson - Alterado em 06/11/2015 - Data de corte alterado de '12-01-2013' para '11-01-2015'

CREATE Procedure [dbo].[spBuscaNFSemDN_Sel] --spBuscaNFSemDN_Sel 'EMBS'

	@Cd_Usuario	Varchar(10)
	
as	

--SET NOCOUNT ON
/* Erbson 02/05/2017 - alterado para a View vwFaturasValidas
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
select  
	NF.nota_fiscal,
	IA.num_proc Num_Proc,
	FA.Codigo,
	--US.Nome_Usuario,
	convert(varchar,emissao,105) Emissao
	--,Fat.num_proc,fat.cd_tp_tx,fat.dc,ia.cd_tp_tx 
from 
	base_nota_fiscal NF with(nolock)
	Join Fatura_ARG FA  with(nolock) on FA.numero=nf.notA_fiscal and codigo=ref_acesso
	Join fatura_Arg_det IA with(nolock) on IA.id_Fat=FA.id_Fat
	Left Join dbo.vwFaturasValidas FAT with(nolock) on fat.num_proc=IA.num_proc and IA.cd_tp_Tx=FAt.cd_tp_tx and IA.dc=fat.dc
	--Left Join @Fatura FAt  on fat.num_proc=IA.num_proc and IA.cd_tp_Tx=FAt.cd_tp_tx and IA.dc=fat.dc
	--Join usuario US with(nolock) on   US.cd_usuario=Nf.cd_usuario
where
	Fat.num_proc is null 
	--and(NF.cd_usuario=@Cd_Usuario or @cd_usuario='')
	and NF.cd_usuario=@Cd_Usuario --Incluido por Rafael Lindenberg -Ticket#100-93676
	--and NF.Cd_Usuario not in ('EMBS')
	and cd_status <>2
	--and emissao >='12-01-2013' --Comentado por Rafael Lindenberg -Ticket#100-93676
	and NF.emissao >='11-01-2015'
	and left(IA.num_proc,5) <> 'IAREM'
	and NF.nota_fiscal not in ('47130','76487','61105',34832,34831)
	--and Ia.num_proc='IMATL201308074BR'
	--and convert(datetime,dt_ins_him,105)>='01-01-2013' 
OPTION(HASH JOIN)
GO
