################################################################################
# This package deploy multiple phase alignment algorithm for 
# multiple objects
################################################################################
import numpy as np

class total_power_max:
    # Total received power maximization

    def __init__(self, res=16, N_round=3):
        # res: 
        # N_round: The number of iterative search round

        self.N_r = N_round
        self.res = res 

    def iterative_search(self, H):
        # This algorithm comes from LAIA (NSDI'19)
        # H: Channel matrix
        # res: The resolution of possible phase choices. The default is 16 (4-bit phase shifter)
        
        N_txs = np.size(H, 1)
        N_tar = np.size(H, 0)

        weight_vec = np.exp(2j * np.pi * np.arange(0, self.res) / self.res)

        aligned_weight_mat = np.ones([N_txs, self.res], dtype=complex)

        for index_round in range(self.N_r):

            # Align the phase for each TX, respectively 
            for index in range(N_txs):
                # calculate the power
                aligned_weight_mat[index][:] = weight_vec
                received_signal_mat = np.dot(H, aligned_weight_mat)
                total_received_power_vec = np.diag(np.dot(received_signal_mat.conj().T, received_signal_mat))
                
                # assign the aligned weight
                aligned_weight_index = total_received_power_vec.argmax() # the index of the max power
                aligned_weight_mat[index][:] = weight_vec[aligned_weight_index] * np.ones([1, self.res])

            aligned_weight_vec = aligned_weight_mat[:, 0]

        return aligned_weight_vec

    def single_object(self, H):
        # Phase alignment for single object. This algorithm is more accurate

        return np.exp(-1j * np.angle(H))

class fair_power_max:
    # Fair received power maximization (maximize the minimal power)

    def __init__(self, res=16, N_round=3):
        # res: 
        # N_round: The number of iterative search round

        self.N_r = N_round
        self.res = res 

    def iterative_search(self, H):
        # This algorithm is fairness version of LAIA (NSDI'19)
        # H: Channel matrix
        # res: The resolution of possible phase choices. The default is 16 (4-bit phase shifter)
        
        N_txs = np.size(H, 1)
        N_tar = np.size(H, 0)

        weight_vec = np.exp(2j * np.pi * np.arange(0, self.res) / self.res)
         
        aligned_weight_mat = np.ones([N_txs, self.res], dtype=complex)

        for index_round in range(self.N_r):

            # Align the phase for each TX, respectively 
            for index in range(N_txs):
                # calculate the power
                aligned_weight_mat[index][:] = weight_vec
                received_signal_mat = np.dot(H, aligned_weight_mat)
                received_power_mat = np.abs(received_signal_mat)**2
                fair_received_power = np.min(received_power_mat, axis=0)

                # assign the aligned weight
                aligned_weight_index = fair_received_power.argmax() # the index of the max power
                aligned_weight_mat[index][:] = weight_vec[aligned_weight_index] * np.ones([1, self.res])

            aligned_weight_vec = aligned_weight_mat[:, 0]

        return aligned_weight_vec
