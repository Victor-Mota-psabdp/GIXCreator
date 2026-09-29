SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spATL_VerificaPrestacaoSemServico_Sel
(
	@Cliente varchar(50)
)
as

   
select PL.cd_pes_grupo Cod, Smart_IMP from Pessoa_LLP PL with(nolock)
join pessoa P with(nolock) on P.cd_pes=PL.cd_pes
join Grupo G with(nolock) on G.cd_Pes_Grupo=PL.Cd_Pes_Grupo 
join Campo_Pessoa CP with(nolock) on G.Cd_Pes_Grupo = CP.cd_pes and Id_Campo = 11 and Campo_Dados = 1
where apelido = @Cliente
/*
select * from pessoa P with(nolock)
join Grupo G with(nolock) on G.cd_Pes_Grupo=P.Cd_Pes
join Campo_Pessoa CP with(nolock) on G.Cd_Pes_Grupo = CP.cd_pes and Id_Campo = 11 and Campo_Dados = 1
where apelido ='UPL DO BRAS - 1615C'

spATL_VerificaPrestacaoSemServico_Sel 'UPL DO BRAS - 1615C'

select * from Pessoa
where apelido = 'UPL DO BRAS - 1615C'
*/
GO
