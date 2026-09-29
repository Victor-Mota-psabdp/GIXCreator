SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[spATL_BuscaAccountSFDC_sel]
as

select ASF.SFDCID,AX.cd_ax,AX.Tipo,(Case when AX.Tipo = 'F' then 'Vendor' else Case when AX.Tipo = 'C' then 'Customer' end end) Tipo_Nome, dbo.FRemoveCaracteresEspeciais(UPPER(PS.Nome_Raz_Soc)) Nome_Raz_Soc,dbo.FRemoveCaracteresEspeciais(UPPER(PS.Cd_Pes))CD_Pes,dbo.FRemoveCaracteresEspeciais(UPPER(EN.Rua + ' ' + EN.Numero)) Endereco,dbo.FRemoveCaracteresEspeciais(UPPER(EN.Cidade)) Cidade,dbo.FRemoveCaracteresEspeciais(UPPER(EN.UF))UF, dbo.FRemoveCaracteresEspeciais(UPPER(P.Nome_Pais)) Nome_Pais,EN.CEP,C.Cd_Int + ' ' + C.Cd_Area_Fone + ' ' + C.Prefixo + ' ' + C.Num_Fone Fone, C.Compl_Fone email from Pessoa_ATL_AX AX with(nolock)
join Account_SFDC ASF with(nolock) on AX.Cd_Pes =ASF.Cd_Pes and AX.cd_ax = ASF.cd_Ax and AX.Tipo = ASF.Tipo
join Pessoa PS with(nolock) on ASF.cd_pes = PS.Cd_Pes
Left join Endereco EN with(nolock) on PS.Cd_Pes = EN.Cd_Pes and EN.Cd_Tp_End = 'COM'
Left join Pais P with(nolock)	on EN.CD_pais = P.Cd_Pais
left join Comunicacao C with(nolock) on PS.Cd_Pes = C.Cd_Pes and C.Cd_Tp_Com = 'AG1'
where  ASF.Dt_Envio is NULL

option(hash join)


GO
