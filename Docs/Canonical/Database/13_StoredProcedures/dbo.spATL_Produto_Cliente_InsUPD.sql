SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Produto_Cliente
CREATE Procedure [dbo].[spATL_Produto_Cliente_InsUPD]
		@Cd_Proc_Cliente	VarChar(30),
		@Cd_Cliente			VarChar(10),
		@Produto_Descr		VarChar(500),
		@NCM_Cliente		VarChar(8),
		@Cd_Prod_OUT		int output
AS

Begin Transaction
	Declare @Cd_Prod	int
	Set @Cd_Prod=(select Isnull(max(cd_prod),0) from produto_cliente)
	SEt @Cd_Prod=@Cd_Prod+1

	set @Produto_Descr = replace(@Produto_Descr,char(9),'')
	
	if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
		BEGIN
			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
				begin
					set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
				end
			if NOT exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
				BEGIN
					Insert into
						Produto_cliente
							(
								cd_prod,
								cd_Proc_Cliente,
								cd_Cliente,
								Produto_Descr,
								NCM_Cliente
							)
						values
							(
								@Cd_Prod,
								@cd_Proc_Cliente,
								@Cd_Cliente,
								@Produto_Descr,
								@NCM_Cliente
							)
				END
		END
	Else
		BEGIN
			--if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
			if exists (select Produto_Descr from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
					Begin
						--if not exists (select Produto_Descr from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente
						--				and left(right(Produto_Descr,len(cd_Proc_Cliente)+1),len(cd_Proc_Cliente)) = cd_Proc_Cliente)						
						--	begin
						--		set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
						--	end
						--else 
						if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente
									and cd_Proc_Cliente <> @cd_Proc_Cliente)
							begin
								set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
							end
					End
					
					
					BEGIN
						Update
							Produto_cliente
						Set
							Produto_Descr=@Produto_Descr,
							NCM_Cliente=@NCM_Cliente
						Where
							cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente
					END
		END
	
	Set @Cd_Prod_OUT=(select cd_prod from produto_cliente Where
					cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)

	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


--Begin Transaction
--	Declare @Cd_Prod int
--	Set @Cd_Prod=(select Isnull(max(cd_prod),0) from produto_cliente)
--	SEt @Cd_Prod=@Cd_Prod+1

--	set @Produto_Descr = replace(@Produto_Descr,char(9),'')
	
--	if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
--		BEGIN
--			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
--				begin
--					set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
--				end
--			if NOT exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
--				BEGIN
--					Insert into
--						Produto_cliente
--							(
--								cd_prod,
--								cd_Proc_Cliente,
--								cd_Cliente,
--								Produto_Descr,
--								NCM_Cliente
--							)
--						values
--							(
--								@Cd_Prod,
--								@cd_Proc_Cliente,
--								@Cd_Cliente,
--								@Produto_Descr,
--								@NCM_Cliente
--							)
--				END
--		END
--	Else
--		BEGIN
--			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
--					begin
--						set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
--					end
--			BEGIN
--				Update
--					Produto_cliente
--				Set
--					Produto_Descr=@Produto_Descr,
--					NCM_Cliente=@NCM_Cliente
--				Where
--					cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente
--			END
--		END
	
 
--	Set @Cd_Prod_OUT=(select cd_prod from produto_cliente Where
--					cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)

--	if @@error <> 0
--		Begin
--			Rollback transaction
--			return -1
--		End

--Commit Transaction

--Begin Transaction
--	Declare @Cd_Prod	int
--	Set @Cd_Prod=(select Isnull(max(cd_prod),0) from produto_cliente)
--	SEt @Cd_Prod=@Cd_Prod+1
--	
--	if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
--		Begin
--			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
--				begin
--					set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
--				end
--			if NOT exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
--				Insert into
--						produto_cliente
--						(
--							cd_prod,
--							cd_Proc_Cliente,
--							cd_Cliente,
--							Produto_Descr,
--							NCM_Cliente
--						)
--					values
--						(
--							@Cd_Prod,
--							@cd_Proc_Cliente,
--							@Cd_Cliente,
--							@Produto_Descr,
--							@NCM_Cliente
--						)
--		end
--	Else
----		if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
--		Begin
----			set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
--
--			Update
--				Produto_cliente
--			Set
--				Produto_Descr=@Produto_Descr,
--				NCM_Cliente=@NCM_Cliente
--			Where
--				cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente
--		End
--	
--
--
--	if @@error <> 0
--		Begin
--			Rollback transaction
--			return -1
--		End
--
--Commit Transaction
--
--
--				
--

GO
