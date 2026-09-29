SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPessoa_Banco_Sel]
AS

	select 
		C.Id_Pes_Banco		[ID],
		C.ID_Item			[ID_Item],
		C.Cd_Pes			[Client Code],
		P.Apelido			[Client Name],		
		C.Id_Pes_Banco		[Bank Type Code],
		T.Nome_Tp_Banco		[Bank Type Name],			
		C.Cd_Banco			[Bank Code],
		C.Cd_Agencia		[Agency Code],
		C.Conta_Corrente	[Current Account],
		C.Cd_Usuario		[User Code],
		US.Nome_Usuario		[User Name],
		C.Dt_Ins			[Insert Date],
		C.Ativo				[Enabled]
	from 
		dbo.Pessoa_Banco C with(nolock)
		join Tipo_Banco	 T with(nolock) on C.Id_Tp_Banco = T.Id_Tp_Banco
		join Pessoa			 P with(nolock) on C.Cd_Pes = P.Cd_Pes
		left join Usuario	US with(nolock) on US.Cd_Usuario = C.Cd_Usuario	
	--where
	--	ativo = 1
			


GO
