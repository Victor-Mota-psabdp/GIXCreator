SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPessoa_Banco_Sel]
		
		@cd_pes varchar(10)

as
	select
		P.Id_Item Item, 
		T.Nome_tp_Banco Bank,
		Cd_Banco,
		Cd_Agencia,
		Conta_Corrente
	FROM
		Pessoa_Banco P
		join Tipo_Banco T on T.Id_Tp_Banco = P.Id_Tp_Banco
	WHERE
		P.cd_pes=@cd_pes







GO
