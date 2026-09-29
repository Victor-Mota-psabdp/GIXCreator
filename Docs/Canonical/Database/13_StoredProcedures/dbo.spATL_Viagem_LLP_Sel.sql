SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Viagem_LLP
--copia da spATLDN_Viagem_LLP_Sel
--spATL_Viagem_LLP_Sel '2','05SGB','I','SSZ','N'
CREATE PROCEDURE [dbo].[spATL_Viagem_LLP_Sel]
(	
	@Id_Navio		Int,
	@NR_Viagem		varchar(8),
	@Modal			varchar(1),
	@cd_local		varchar(3),
	@Tipo			char(1)
)
	
as

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			V.ID_Viagem		[Code],
			V.ID_Navio		[Vessel Code],			
			NV.Nome_Navio	[Vessel Name],
			Nr_viagem		[Voyage],
			Ano_Viagem		[Year],
			V.Cd_Dst		[Origin/Destination Code],
			L.Nome_Local	[Origin/Destination Name],
			--O.Descricao_OP	[Port Operator],
			V.Id_Terminal	[Terminal Code],
			T.Nome_Terminal	[Terminal Name],
			convert(varchar(10),V.ETD,103)	[ETD Date],
			convert(varchar(10),V.ATD,103)	[ATD Date],
			convert(varchar(10),V.ETA,103)	[ETA Date],
			convert(varchar(10),V.ATA,103)	[ATA Date],	
			V.Manifesto		[Manifest],
			V.Notes			[Notes]	,
			V.ativo			[Enabled],
			v.cd_usuario	[User Code],
			US.Nome_Usuario	[User Name]			
			--'Saved' [Status]
		from Viagem_LLP V
			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
			left join Localidade L on L.Cd_Local  = V.Cd_Dst
			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
			left join Usuario US on US.Cd_Usuario = V.Cd_Usuario
		 where 
			NV.Nome_Navio <> ''
			and Modal = @Modal
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
			select 
			V.ID_Viagem		[Code],
			V.ID_Navio		[Vessel Code],			
			NV.Nome_Navio	[Vessel Name],
			Nr_viagem		[Voyage],
			Ano_Viagem		[Year],
			V.Cd_Dst		[Origin/Destination Code],
			L.Nome_Local	[Origin/Destination Name],
			--O.Descricao_OP	[Port Operator],
			V.Id_Terminal	[Terminal Code],
			T.Nome_Terminal	[Terminal Name],
			convert(varchar(10),V.ETD,103)	[ETD Date],
			convert(varchar(10),V.ATD,103)	[ATD Date],
			convert(varchar(10),V.ETA,103)	[ETA Date],
			convert(varchar(10),V.ATA,103)	[ATA Date],	
			V.Manifesto		[Manifest],
			V.Notes			[Notes]	,
			V.ativo			[Enabled],
			v.cd_usuario	[User Code],
			US.Nome_Usuario	[User Name]			
			--'Saved' [Status]
		from Viagem_LLP V
			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
			left join Localidade L on L.Cd_Local  = V.Cd_Dst
			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
			left join Usuario US on US.Cd_Usuario = V.Cd_Usuario
		 where 
			V.ID_Navio = @Id_Navio			
			and NV.Nome_Navio <> ''
			and V.Modal = @Modal
			
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			V.ID_Viagem		[Code],
			V.ID_Navio		[Vessel Code],			
			NV.Nome_Navio	[Vessel Name],
			Nr_viagem		[Voyage],
			Ano_Viagem		[Year],
			V.Cd_Dst		[Origin/Destination Code],
			L.Nome_Local	[Origin/Destination Name],
			--O.Descricao_OP	[Port Operator],
			V.Id_Terminal	[Terminal Code],
			T.Nome_Terminal	[Terminal Name],
			convert(varchar(10),V.ETD,103)	[ETD Date],
			convert(varchar(10),V.ATD,103)	[ATD Date],
			convert(varchar(10),V.ETA,103)	[ETA Date],
			convert(varchar(10),V.ATA,103)	[ATA Date],	
			V.Manifesto		[Manifest],
			V.Notes			[Notes]	,
			V.ativo			[Enabled],
			v.cd_usuario	[User Code],
			US.Nome_Usuario	[User Name]			
			--'Saved' [Status]
		from Viagem_LLP V
			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
			left join Localidade L on L.Cd_Local  = V.Cd_Dst
			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
			left join Usuario US on US.Cd_Usuario = V.Cd_Usuario
		 where 
			V.ID_Navio = @Id_Navio  
			and V.Nr_viagem = @NR_Viagem
			and NV.Nome_Navio <> ''
			and Modal = @Modal
			and V.Cd_Dst = @Cd_Local
	End
	
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select 
--			V.ID_Viagem		[Code],
--			V.ID_Navio		[Vessel Code],			
--			NV.Nome_Navio	[Vessel Name],
--			Nr_viagem		[Voyage],
--			Ano_Viagem		[Year],
--			V.Cd_Dst		[Origin/Destination Code],
--			L.Nome_Local	[Origin/Destination Name],
--			--O.Descricao_OP	[Port Operator],
--			V.Id_Terminal	[Terminal Code],
--			T.Nome_Terminal	[Terminal Name],
--			convert(varchar(10),V.ETD,103)	[ETD Date],
--			convert(varchar(10),V.ATD,103)	[ATD Date],
--			convert(varchar(10),V.ETA,103)	[ETA Date],
--			convert(varchar(10),V.ATA,103)	[ATA Date],	
--			V.Manifesto		[Manifesto],
--			V.Notes			[Notes]	,
--			V.ativo			[Ativo]
--			--'Saved' [Status]
--		from Viagem_LLP V
--			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
--			left join Localidade L on L.Cd_Local  = V.Cd_Dst
--			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
--			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
--		 where 
--			V.ID_Navio = @Id_Navio and 
--			V.Nr_viagem  <> @NR_Viagem
--			and NV.Nome_Navio <> ''
--			and Modal = @Modal
	
--	End

--if @Tipo = 'A' or @Tipo = 'B'
--	Begin
--		select 
--			V.ID_Viagem		[Code],
--			V.ID_Navio		[Vessel Code],			
--			NV.Nome_Navio	[Vessel Name],
--			Nr_viagem		[Voyage],
--			Ano_Viagem		[Year],
--			V.Cd_Dst		[Origin/Destination Code],
--			L.Nome_Local	[Origin/Destination Name],
--			--O.Descricao_OP	[Port Operator],
--			V.Id_Terminal	[Terminal Code],
--			T.Nome_Terminal	[Terminal Name],
--			convert(varchar(10),V.ETD,103)	[ETD Date],
--			convert(varchar(10),V.ATD,103)	[ATD Date],
--			convert(varchar(10),V.ETA,103)	[ETA Date],
--			convert(varchar(10),V.ATA,103)	[ATA Date],	
--			V.Manifesto		[Manifesto],
--			V.Notes			[Notes]	,
--			V.ativo			[Ativo]
--			--'Saved' [Status]
--		from Viagem_LLP V
--			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
--			left join Localidade L on L.Cd_Local  = V.Cd_Dst
--			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
--			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
--		 where 
--			Modal = @Modal and
--			NV.Nome_Navio <> ''
			
--	End

--if @Tipo = 'C' or @Tipo = 'D'
--	Begin
--			select 
--			V.ID_Viagem		[Code],
--			V.ID_Navio		[Vessel Code],			
--			NV.Nome_Navio	[Vessel Name],
--			Nr_viagem		[Voyage],
--			Ano_Viagem		[Year],
--			V.Cd_Dst		[Origin/Destination Code],
--			L.Nome_Local	[Origin/Destination Name],
--			--O.Descricao_OP	[Port Operator],
--			V.Id_Terminal	[Terminal Code],
--			T.Nome_Terminal	[Terminal Name],
--			convert(varchar(10),V.ETD,103)	[ETD Date],
--			convert(varchar(10),V.ATD,103)	[ATD Date],
--			convert(varchar(10),V.ETA,103)	[ETA Date],
--			convert(varchar(10),V.ATA,103)	[ATA Date],	
--			V.Manifesto		[Manifesto],
--			V.Notes			[Notes]	,
--			V.ativo			[Ativo]
--			--'Saved' [Status]
--		from Viagem_LLP V
--			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
--			left join Localidade L on L.Cd_Local  = V.Cd_Dst
--			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
--			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
--		 where
--			Modal = @Modal and 
--			NV.Nome_Navio <> '' and
--			V.ID_Navio = @Id_Navio			
--	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select 
--			V.ID_Viagem		[Code],
--			V.ID_Navio		[Vessel Code],			
--			NV.Nome_Navio	[Vessel Name],
--			Nr_viagem		[Voyage],
--			Ano_Viagem		[Year],
--			V.Cd_Dst		[Origin/Destination Code],
--			L.Nome_Local	[Origin/Destination Name],
--			--O.Descricao_OP	[Port Operator],
--			V.Id_Terminal	[Terminal Code],
--			T.Nome_Terminal	[Terminal Name],
--			convert(varchar(10),V.ETD,103)	[ETD Date],
--			convert(varchar(10),V.ATD,103)	[ATD Date],
--			convert(varchar(10),V.ETA,103)	[ETA Date],
--			convert(varchar(10),V.ATA,103)	[ATA Date],	
--			V.Manifesto		[Manifesto],
--			V.Notes			[Notes]	,
--			V.ativo			[Ativo]
--			--'Saved' [Status]
--		from Viagem_LLP V
--			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
--			left join Localidade L on L.Cd_Local  = V.Cd_Dst
--			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
--			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
--		 where 
--			Modal = @Modal and 
--			NV.Nome_Navio <> '' and
--			V.ID_Navio = @Id_Navio and
--			V.Nr_viagem  like @NR_Viagem			
--	End
	
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select 
--			V.ID_Viagem		[Code],
--			V.ID_Navio		[Vessel Code],			
--			NV.Nome_Navio	[Vessel Name],
--			Nr_viagem		[Voyage],
--			Ano_Viagem		[Year],
--			V.Cd_Dst		[Origin/Destination Code],
--			L.Nome_Local	[Origin/Destination Name],
--			--O.Descricao_OP	[Port Operator],
--			V.Id_Terminal	[Terminal Code],
--			T.Nome_Terminal	[Terminal Name],
--			convert(varchar(10),V.ETD,103)	[ETD Date],
--			convert(varchar(10),V.ATD,103)	[ATD Date],
--			convert(varchar(10),V.ETA,103)	[ETA Date],
--			convert(varchar(10),V.ATA,103)	[ATA Date],	
--			V.Manifesto		[Manifesto],
--			V.Notes			[Notes]	,
--			V.ativo			[Ativo]
--			--'Saved' [Status]
--		from Viagem_LLP V
--			left Join navio_LLP NV on V.id_navio = NV.Id_Navio
--			left join Localidade L on L.Cd_Local  = V.Cd_Dst
--			--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
--			left join Terminal T on T.Cd_Terminal = V.Id_Terminal
--		 where 
--			Modal = @Modal and 
--			NV.Nome_Navio <> '' and
--			V.ID_Navio = @Id_Navio and
--			V.Nr_viagem  like @NR_Viagem and
--			v.Cd_Dst = @cd_local
	
--	End

GO
