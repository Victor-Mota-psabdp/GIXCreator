SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Pessoa_Banco
Create procedure [dbo].[spATL_Pessoa_Banco_Sel]
(	
	@Cd_Pes varchar(10),
	@Id_Tp_Banco int,
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A'
	Begin
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
	End	

if  @Tipo = 'B'
	Begin
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
		Where
			C.Ativo = 1
	End	


if @Tipo = 'C'
	Begin
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
		where
			C.Cd_Pes = @Cd_Pes 			
	End

if @Tipo = 'D' 
	Begin
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
		where
			C.Cd_Pes = @Cd_Pes 
			and C.Ativo = 1
	End

if @Tipo = 'N'
	Begin
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
		where
			C.Cd_Pes = @Cd_Pes 
			and C.Id_Tp_Banco = @Id_Tp_Banco 
	End

if  @Tipo = 'O'
	Begin
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
		where
			C.Cd_Pes = @Cd_Pes 
			and C.Id_Tp_Banco = @Id_Tp_Banco 
			and C.Ativo = 1
	End

	

GO
