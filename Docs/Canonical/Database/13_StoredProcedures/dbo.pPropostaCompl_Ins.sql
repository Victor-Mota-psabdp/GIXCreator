SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pPropostaCompl_Ins 
(
@Proposta		VarChar(12),
@NovaProp		VarChar(12) = '' OUTPUT
)
AS
	Declare @ItemCompl	Int
	Begin Transaction 
	Set @ItemCompl = (IsNull((Select TOP 1 ASCII(Right(ProCod,1)) From Proposta Where Left(ProCod, 11) = Left(@Proposta, 11)  Order by ProCod Desc),64)) + 1 
	Set @NovaProp = Left(@Proposta, 11) + Char(@ItemCompl)

	Insert Into Proposta 
	Select @NovaProp, CD_PES, CD_TP_COM, PROFAX, PRODATA, 4, PROCABEC, PROCONSULTOR, PROVALIDADE, PROOBS, PROROD, PRODTSOL, PROPRODUTO, 0 From Proposta Where ProCod = @Proposta
	if @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	
	If substring(@Proposta,2,1 ) = 'A'
		Begin 
			Insert into Proposta_Rot_Aer 
			Select @NovaProp, PRAID, PRAOrg, PRADst, PRAGat, TptID, PRAFreq, Cd_Tp_Moeda, PRATTime, Cd_Cia_Aer From Proposta_Rot_Aer Where ProCod = @Proposta
			If @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -2
				End 			
		
			Insert Into proposta_tar_aer 
			Select @NovaProp, PRAID, PTARangMin, PTARangMax, PTAValor From Proposta_Tar_Aer Where ProCod = @Proposta
			If @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -3
				End 			

			insert Into proposta_tax_aer
			Select @NovaProp, PRAID, PXAID, Cd_Tp_Tx, Cd_Tp_Moeda, PXAValor, PXAEspecif, PXATipo From Proposta_Tax_Aer Where ProCod = @Proposta

			If @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -4
				End 			
			Else
				Begin 
					Commit Transaction 		
					Return 1 
				End 
	
			

		End 
	Else
		Begin 
			Insert Into proposta_rot_mar
			Select @NovaProp, PRMID, PRMOrg, PRMDst, PRMGat, Cd_Armador, TptID, Cd_Tp_Moeda, PRMTTime, PRMFreq From proposta_rot_mar Where ProCod = @Proposta
			If @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -2
				End 			

			Insert Into proposta_tar_mar 
			Select @NovaProp, PRMID, Cd_Tp_Cont, PTMValor From proposta_tar_mar  Where ProCod = @Proposta
			If @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -3
				End 		

			Insert into proposta_tax_mar
			Select @NovaProp, PRMID, PXMID, Cd_Tp_Tx, Cd_Tp_Moeda, PXMValor, PXMEspecif, PXMTipo From Proposta_Tax_Mar Where ProCod = @Proposta
			If @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -4
				End 			
			Else
				Begin 
					Commit Transaction 		
					Return 1 
				End 

		End
GO
