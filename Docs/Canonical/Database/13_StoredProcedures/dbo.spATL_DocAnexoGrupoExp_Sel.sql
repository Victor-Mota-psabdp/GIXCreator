SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_DocAnexoGrupoExp_Sel 'Grupo Oxiteno', '2016-01-01','2016-10-25','','62545686001559'

CREATE procedure [dbo].[spATL_DocAnexoGrupoExp_Sel]
(
@Grupo as varchar(50),
@Dt_Inicial datetime,
@Dt_Final datetime,
@JOB varchar(16),
@CNPJ varchar(50)
)as

select 
HOU.Num_Proc [Job],
dbo.[fBusca_Docs_PO_Modal_COALESCE](HOU.Num_Proc,3) [Sales Order],
ETD [ETD],
DC27.Anexado_Em [Survey],
DC36.Anexado_Em [Bordero],
DC103.Anexado_Em [Courier1],
DC94.Anexado_Em [Courier 2],
DC65.Anexado_Em [Saque],
DC21.Anexado_Em [Seguro],
DC187.Anexado_Em [VGM]
from vwHouse_Exp HOU with(nolock)
left Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
left join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
left join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
left Join Doc_Anexos DC27 with(nolock) on HOU.Num_Proc = DC27.Num_Proc and DC27.ID_DC = 27
left Join Doc_Anexos DC36 with(nolock) on HOU.Num_Proc = DC36.Num_Proc and DC36.ID_DC = 36
left Join Doc_Anexos DC103 with(nolock) on HOU.Num_Proc = DC103.Num_Proc and DC103.ID_DC = 103
left Join Doc_Anexos DC94 with(nolock) on HOU.Num_Proc = DC94.Num_Proc and DC94.ID_DC = 94
left Join Doc_Anexos DC65 with(nolock) on HOU.Num_Proc = DC65.Num_Proc and DC65.ID_DC = 65
left Join Doc_Anexos DC21 with(nolock) on HOU.Num_Proc = DC21.Num_Proc and DC21.ID_DC = 21
left Join Doc_Anexos DC187 with(nolock) on HOU.Num_Proc = DC187.Num_Proc and DC187.ID_DC = 187
left join Pessoa C with(nolock) on C.Cd_Pes= HOU.Cd_Export
where 
(PG.Apelido = @Grupo or @Grupo ='Grupo ALL') 
and ETD between @Dt_Inicial and @Dt_Final 
and (REPLACE(REPLACE(right(C.Num_CPF_CNPJ,14),'/',''),'-','') = @CNPJ or @CNPJ='')
and (HOU.Num_Proc = @JOB or @JOB = '')
order by ETD 
GO
