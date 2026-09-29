SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from pessoa where cd_pes = 'P000006830'
--select * from fatura_chb where processo_pc in ('EMOXT201303097BR','EMOXT201302129BR','EMOXT201302149BR')
--
--where notA_fiscal='001053 a 001055' and num_proc='IACSR20081002701'
----[spFaturaConsolidada_Sel]'GRUPO OXITENO','E','2013-01-23','2013-04-23'
--
--Fatura_Consolidada
--ID 
--fatcod
--cliente
--vlr_org

CREATE procedure [dbo].[spFaturaConsolidada_Sel]-- 'GRUPO OXITENO','E','2013-01-01','2013-05-01'
(
@Apelido		varchar(20),
@Tipo			varchar(1),
@DataInicial	datetime,
@DataFinal		datetime
)

AS

select It.fatcod Referencia, vlr_org from item_fat IT
	join fatura_CHB F on F.fatura_PC = It.fatcod
	join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=F.Cd_pes_PC
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
 where	
	cd_tp_tx in ('XCA','XCQ' ,'XEQ','XEU')
	and dc='C'	
	and data_PC between @DataInicial and @DataFinal
	and Status_PC = 'E' and PG.APelido = @Apelido
	and IT.num_proc like @Tipo + '%'

GO
