SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spATL_BuscaBancoPessoa_Sel] 'P000020008',''
CREATE procedure [dbo].[spATL_BuscaBancoPessoa_Sel] 
(
	@Cd_Pes varchar(10),
	@Apelido varchar(20)
)
as

Declare @Temp Table(
	Dado varchar(50)
)

	if @Apelido <> ''
		Begin
			Set @Cd_Pes = (select Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)
			PRINT @Cd_PEs
		End
	insert @Temp
	Select Campo_Exibicao + ': ' + Campo_Dados from Campo_Pessoa CP
	join Tipo_Campo_Pessoa TC on CP.Id_Campo = TC.Id_Campo
	where CP.Cd_Pes = @Cd_Pes and Descr_Campo in ('Banco','Codigo Banco','Codigo Agencia','Conta Corrente')
	insert @Temp
	select (Case when cd_tp_grupo = 'CPF' then 'CPF' else 'CNPJ' end) + ':' +  Num_CPF_CNPJ from Pessoa 
	where Cd_Pes = @Cd_Pes
	
	
	select Dado from @Temp

	
	



GO
