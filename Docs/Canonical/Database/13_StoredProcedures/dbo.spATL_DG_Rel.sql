SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_DG_Rel 'IMHEX201803007BR' 

--select * from vwHouse_Imp where Num_Proc like 'IMSTL%'

Create procedure [dbo].[spATL_DG_Rel]			

(
@Num_Proc varchar(16)
)
as

select HOU.Num_Proc,CLI.Nome_Raz_Soc, dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,10) Documento_Fiscal, T.Nome_Terminal,TPO.Descricao_OP Termnial_Pier,PC.cd_Proc_Cliente,
PP.cd_prod,	uncode,	classCode,	HazMat_Name_Material,	HazMat_Description,	HazMat_Contact,	HazMat_Phone,	FlashPoint,	measureCode,	packingCode,	EMS_MFAG_NUMBERS,
GP.Apelido Grupo,HOU.Vessel,R.Nome_Usuario  from vwHouse_Imp HOU with(nolock)
join Pessoa CLI with(nolock) on HOU.Cd_Consig = CLI.Cd_Pes
left join Terminal T with(nolock) on HOU.Cd_Terminal = T.Cd_Terminal
left join Campo_Processo CP139 with(nolock) on CP139.Num_Proc = HOU.Num_Proc and CP139.Id_Campo = '139'
left join Tipo_Operador_Portuario TPO with(nolock) on CP139.Campo_Dados = TPO.ID_OP
left join vwPedidoShipxPedido vwP with(nolock) on vwP.Num_Proc = HOU.Num_Proc
left join Produto_Cliente PC with(nolock) on PC.cd_prod = vwP.cd_produto
left join Produto_Perigoso PP with(nolock) on PC.cd_prod  = PP.cd_prod
join Pessoa_LLP PL with(nolock)  on HOU.Cd_Consig = PL.Cd_Pes
join Pessoa GP with(nolock)  on PL.Cd_Pes_Grupo = GP.Cd_Pes
join Grupo Grup with(nolock) on PL.Cd_Pes_Grupo = Grup.Cd_Pes_Grupo
join Usuario R with(nolock) on Grup.Responsavel = R.Cd_Usuario
where HOU.Num_Proc = @Num_Proc
group by
HOU.Num_Proc,CLI.Nome_Raz_Soc, dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,10) , T.Nome_Terminal,TPO.Descricao_OP  ,PC.cd_Proc_Cliente,
PP.cd_prod,	uncode,	classCode,	HazMat_Name_Material,	HazMat_Description,	HazMat_Contact,	HazMat_Phone,	FlashPoint,	measureCode,	packingCode,	EMS_MFAG_NUMBERS,
GP.Apelido ,HOU.Vessel,R.Nome_Usuario

union all

select HOU.Num_Proc,CLI.Nome_Raz_Soc, dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,10) Documento_Fiscal, T.Nome_Terminal,TPO.Descricao_OP Termnial_Pier,PC.cd_Proc_Cliente,
PP.cd_prod,	uncode,	classCode,	HazMat_Name_Material,	HazMat_Description,	HazMat_Contact,	HazMat_Phone,	FlashPoint,	measureCode,	packingCode,	EMS_MFAG_NUMBERS,
GP.Apelido Grupo,HOU.Vessel,R.Nome_Usuario  from vwHouse_EXP HOU with(nolock)
join Pessoa CLI with(nolock) on HOU.Cd_Export = CLI.Cd_Pes
left join Terminal T with(nolock) on HOU.Cd_Terminal = T.Cd_Terminal
left join Campo_Processo CP139 with(nolock) on CP139.Num_Proc = HOU.Num_Proc and CP139.Id_Campo = '139'
left join Tipo_Operador_Portuario TPO with(nolock) on CP139.Campo_Dados = TPO.ID_OP
left join vwPedidoShipxPedido vwP with(nolock) on vwP.Num_Proc = HOU.Num_Proc
left join Produto_Cliente PC with(nolock) on PC.cd_prod = vwP.cd_produto
left join Produto_Perigoso PP with(nolock) on PC.cd_prod  = PP.cd_prod
join Pessoa_LLP PL with(nolock)  on HOU.Cd_Export = PL.Cd_Pes
join Pessoa GP with(nolock)  on PL.Cd_Pes_Grupo = GP.Cd_Pes
join Grupo Grup with(nolock) on PL.Cd_Pes_Grupo = Grup.Cd_Pes_Grupo
join Usuario R with(nolock) on Grup.Responsavel = R.Cd_Usuario
where HOU.Num_Proc = @Num_Proc
group by
HOU.Num_Proc,CLI.Nome_Raz_Soc, dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,10) , T.Nome_Terminal,TPO.Descricao_OP  ,PC.cd_Proc_Cliente,
PP.cd_prod,	uncode,	classCode,	HazMat_Name_Material,	HazMat_Description,	HazMat_Contact,	HazMat_Phone,	FlashPoint,	measureCode,	packingCode,	EMS_MFAG_NUMBERS,
GP.Apelido ,HOU.Vessel,R.Nome_Usuario
GO
