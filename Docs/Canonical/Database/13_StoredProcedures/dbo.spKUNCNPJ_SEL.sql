SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spKUNCNPJ_SEL]

as


/*
select distinct Num_Cpf_CNPJ ,apelido from dbo.Pessoa_ATL_AX AX 
Join Pessoa PP on pp.cd_pes=AX.cd_pes 
Join Endereco ED on ED.cd_pes=PP.cd_pes where UF='PE' and tipo <> 'I'
and (num_rg_ie is null or num_rg_ie = '')

select * from pessoa where num_cpf_cnpj='42150391002203'
*/

--select * from pessoa --set num_rg_ie='26653297'
--where num_CPF_CNPJ in --='42150391003277' 
--(
select distinct Num_Cpf_CNPJ  from dbo.Pessoa_ATL_AX AX 
Join Pessoa PP on pp.cd_pes=AX.cd_pes 
Join Endereco ED on ED.cd_pes=PP.cd_pes where UF='RS' and tipo <> 'I'
--and (num_rg_ie is null or num_rg_ie = '')
and len(cep)<>8
--)
GO
